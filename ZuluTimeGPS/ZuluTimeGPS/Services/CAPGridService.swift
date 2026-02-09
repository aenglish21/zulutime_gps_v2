import Foundation
import CoreLocation

/// Converts GPS coordinates to CAP (Civil Air Patrol) grid references.
///
/// The CAP grid system is based on FAA VFR Sectional Aeronautical Charts.
/// Each sectional chart is divided into 15' x 15' (0.25° x 0.25°) grid squares,
/// numbered from the northwest corner going east, then south.
/// Output format: "CHARLOTTE 087"
struct CAPGridService {

    struct SectionalChart {
        let name: String
        let northLat: Double
        let southLat: Double
        let westLon: Double   // Negative for Western hemisphere
        let eastLon: Double   // Negative for Western hemisphere

        func contains(_ coord: CLLocationCoordinate2D) -> Bool {
            coord.latitude >= southLat && coord.latitude < northLat &&
            coord.longitude >= westLon && coord.longitude < eastLon
        }

        var columnsPerRow: Int {
            Int(((eastLon - westLon) / 0.25).rounded())
        }

        func gridNumber(for coord: CLLocationCoordinate2D) -> Int {
            let row = Int((northLat - coord.latitude) / 0.25)
            let col = Int((coord.longitude - westLon) / 0.25)
            return row * columnsPerRow + col + 1
        }
    }

    // MARK: - FAA VFR Sectional Chart Boundaries (CONUS + AK/HI)
    // Approximate boundaries based on standard FAA chart coverage areas.

    static let charts: [SectionalChart] = [
        // --- Northern tier (~44°N – 49°N) ---
        SectionalChart(name: "SEATTLE",       northLat: 48.0, southLat: 44.0, westLon: -126.0, eastLon: -118.0),
        SectionalChart(name: "GREAT FALLS",   northLat: 48.0, southLat: 44.0, westLon: -118.0, eastLon: -108.0),
        SectionalChart(name: "BILLINGS",      northLat: 48.0, southLat: 44.0, westLon: -112.0, eastLon: -104.0),
        SectionalChart(name: "TWIN CITIES",   northLat: 48.0, southLat: 44.0, westLon: -98.0,  eastLon: -90.0),
        SectionalChart(name: "GREEN BAY",     northLat: 48.0, southLat: 44.0, westLon: -92.0,  eastLon: -84.0),
        SectionalChart(name: "LAKE HURON",    northLat: 48.0, southLat: 44.0, westLon: -86.0,  eastLon: -78.0),
        SectionalChart(name: "MONTREAL",      northLat: 48.0, southLat: 44.0, westLon: -78.0,  eastLon: -70.0),
        SectionalChart(name: "HALIFAX",        northLat: 48.0, southLat: 44.0, westLon: -70.0,  eastLon: -62.0),

        // --- Upper-mid tier (~40°N – 44°N) ---
        SectionalChart(name: "KLAMATH FALLS", northLat: 44.0, southLat: 40.0, westLon: -126.0, eastLon: -118.0),
        SectionalChart(name: "SALT LAKE CITY",northLat: 42.0, southLat: 38.0, westLon: -118.0, eastLon: -108.0),
        SectionalChart(name: "OMAHA",         northLat: 44.0, southLat: 40.0, westLon: -104.0, eastLon: -96.0),
        SectionalChart(name: "CHICAGO",       northLat: 44.0, southLat: 40.0, westLon: -92.0,  eastLon: -84.0),
        SectionalChart(name: "DETROIT",       northLat: 44.0, southLat: 40.0, westLon: -86.0,  eastLon: -80.0),
        SectionalChart(name: "NEW YORK",      northLat: 42.0, southLat: 38.0, westLon: -78.0,  eastLon: -70.0),

        // --- Mid tier (~36°N – 42°N) ---
        SectionalChart(name: "SAN FRANCISCO", northLat: 40.0, southLat: 36.0, westLon: -126.0, eastLon: -120.0),
        SectionalChart(name: "DENVER",        northLat: 42.0, southLat: 38.0, westLon: -108.0, eastLon: -102.0),
        SectionalChart(name: "WICHITA",       northLat: 40.0, southLat: 36.0, westLon: -102.0, eastLon: -96.0),
        SectionalChart(name: "KANSAS CITY",   northLat: 41.0, southLat: 37.0, westLon: -98.0,  eastLon: -92.0),
        SectionalChart(name: "ST LOUIS",      northLat: 41.0, southLat: 37.0, westLon: -92.0,  eastLon: -86.0),
        SectionalChart(name: "CINCINNATI",    northLat: 41.0, southLat: 37.0, westLon: -86.0,  eastLon: -80.0),
        SectionalChart(name: "WASHINGTON",    northLat: 41.0, southLat: 37.0, westLon: -80.0,  eastLon: -74.0),

        // --- Lower-mid tier (~32°N – 38°N) ---
        SectionalChart(name: "LOS ANGELES",   northLat: 36.0, southLat: 32.0, westLon: -122.0, eastLon: -116.0),
        SectionalChart(name: "LAS VEGAS",     northLat: 38.0, southLat: 34.0, westLon: -118.0, eastLon: -112.0),
        SectionalChart(name: "PHOENIX",       northLat: 36.0, southLat: 32.0, westLon: -114.0, eastLon: -108.0),
        SectionalChart(name: "ALBUQUERQUE",   northLat: 36.0, southLat: 32.0, westLon: -108.0, eastLon: -102.0),
        SectionalChart(name: "DALLAS-FT WORTH", northLat: 36.0, southLat: 32.0, westLon: -100.0, eastLon: -94.0),
        SectionalChart(name: "MEMPHIS",       northLat: 38.0, southLat: 34.0, westLon: -92.0,  eastLon: -86.0),
        SectionalChart(name: "ATLANTA",       northLat: 36.0, southLat: 32.0, westLon: -86.0,  eastLon: -80.0),
        SectionalChart(name: "CHARLOTTE",     northLat: 38.0, southLat: 34.0, westLon: -84.0,  eastLon: -76.0),

        // --- Southern tier (~24°N – 32°N) ---
        SectionalChart(name: "EL PASO",       northLat: 34.0, southLat: 30.0, westLon: -108.0, eastLon: -102.0),
        SectionalChart(name: "SAN ANTONIO",   northLat: 32.0, southLat: 28.0, westLon: -102.0, eastLon: -96.0),
        SectionalChart(name: "HOUSTON",       northLat: 32.0, southLat: 28.0, westLon: -98.0,  eastLon: -92.0),
        SectionalChart(name: "NEW ORLEANS",   northLat: 32.0, southLat: 28.0, westLon: -92.0,  eastLon: -86.0),
        SectionalChart(name: "JACKSONVILLE",  northLat: 32.0, southLat: 28.0, westLon: -86.0,  eastLon: -80.0),
        SectionalChart(name: "BROWNSVILLE",   northLat: 28.0, southLat: 24.0, westLon: -100.0, eastLon: -96.0),
        SectionalChart(name: "MIAMI",         northLat: 28.0, southLat: 24.0, westLon: -84.0,  eastLon: -78.0),

        // --- Alaska (simplified) ---
        SectionalChart(name: "ANCHORAGE",     northLat: 64.0, southLat: 58.0, westLon: -156.0, eastLon: -144.0),
        SectionalChart(name: "FAIRBANKS",     northLat: 68.0, southLat: 62.0, westLon: -156.0, eastLon: -142.0),
        SectionalChart(name: "JUNEAU",        northLat: 62.0, southLat: 56.0, westLon: -142.0, eastLon: -130.0),

        // --- Hawaii ---
        SectionalChart(name: "HONOLULU",      northLat: 22.5, southLat: 18.5, westLon: -161.0, eastLon: -154.0),
    ]

    // MARK: - Public API

    /// Returns the CAP grid reference for a given coordinate, e.g. "CHARLOTTE 087".
    /// Returns nil if the coordinate is outside all defined sectional charts.
    static func gridReference(for coordinate: CLLocationCoordinate2D) -> String? {
        guard let chart = charts.first(where: { $0.contains(coordinate) }) else {
            return nil
        }
        let gridNum = chart.gridNumber(for: coordinate)
        return String(format: "%@ %03d", chart.name, gridNum)
    }

    /// Returns just the sectional chart name, or nil if outside coverage.
    static func sectionalName(for coordinate: CLLocationCoordinate2D) -> String? {
        charts.first(where: { $0.contains(coordinate) })?.name
    }

    /// Returns just the grid number, or nil if outside coverage.
    static func gridNumber(for coordinate: CLLocationCoordinate2D) -> Int? {
        guard let chart = charts.first(where: { $0.contains(coordinate) }) else {
            return nil
        }
        return chart.gridNumber(for: coordinate)
    }
}
