import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var statusMessage = "Location not initialized"
    @Published private(set) var isTracking = false

    private let locationManager = CLLocationManager()

    // Formatted coordinate strings
    var latitude: String {
        guard let loc = currentLocation else { return "--" }
        return String(format: "%.6f", loc.coordinate.latitude)
    }

    var longitude: String {
        guard let loc = currentLocation else { return "--" }
        return String(format: "%.6f", loc.coordinate.longitude)
    }

    var altitude: String {
        guard let loc = currentLocation else { return "--" }
        return String(format: "%.1f m", loc.altitude)
    }

    var accuracy: String {
        guard let loc = currentLocation else { return "--" }
        return String(format: "\u{00B1}%.1f m", loc.horizontalAccuracy)
    }

    var capGrid: String {
        guard let loc = currentLocation else { return "--" }
        return CAPGridService.gridReference(for: loc.coordinate) ?? "Outside coverage"
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: - Public Methods

    func startTracking() {
        guard !isTracking else { return }

        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            statusMessage = "Requesting permission..."
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            statusMessage = "Location permission denied"
        case .authorizedWhenInUse, .authorizedAlways:
            beginLocationUpdates()
        @unknown default:
            statusMessage = "Unknown authorization status"
        }
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
        isTracking = false
        statusMessage = "Tracking stopped"
    }

    func refreshLocation() {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            statusMessage = "Location permission not granted"
            return
        }
        statusMessage = "Getting location..."
        locationManager.requestLocation()
    }

    // MARK: - Private Methods

    private func beginLocationUpdates() {
        isTracking = true
        statusMessage = "Acquiring location..."
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        statusMessage = isTracking ? "Location Active" : "Location updated"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        statusMessage = "Error: \(error.localizedDescription)"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            statusMessage = "Location permission granted"
            beginLocationUpdates()
        case .denied:
            statusMessage = "Location permission denied"
            isTracking = false
        case .restricted:
            statusMessage = "Location access restricted"
            isTracking = false
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
