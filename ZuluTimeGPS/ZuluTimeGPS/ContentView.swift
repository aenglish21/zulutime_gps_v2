import SwiftUI

struct ContentView: View {
    @StateObject private var timeService = TimeService()
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // --- UTC Time ---
                    VStack(spacing: 8) {
                        Text("Zulu Time")
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(.white)

                        Text(timeService.utcTimeFormatted)
                            .font(.system(size: 50, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        Text(timeService.utcDateFormatted)
                            .font(.system(size: 24, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 24)

                    Spacer().frame(height: 48)

                    // --- Local Time ---
                    VStack(spacing: 8) {
                        Text("Local Time")
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(.white)

                        Text(timeService.localTimeFormatted)
                            .font(.system(size: 50, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        Text(timeService.localDateFormatted)
                            .font(.system(size: 24, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))

                        Text(timeService.timezoneOffset)
                            .font(.system(size: 20, design: .monospaced))
                            .foregroundColor(.white.opacity(0.54))
                    }

                    Spacer().frame(height: 48)

                    // --- GPS Location Card ---
                    GPSCardView(locationService: locationService)
                }
                .padding(.horizontal, 24)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Zulu Time")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.zuluYellow)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        locationService.refreshLocation()
                    } label: {                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            locationService.startTracking()
        }
    }
}

// MARK: - GPS Card

struct GPSCardView: View {
    @ObservedObject var locationService: LocationService

    var body: some View {
        VStack(spacing: 16) {
            // Header row
            HStack {
                Image(systemName: locationService.isTracking ? "location.fill" : "location.slash")
                    .font(.system(size: 24))
                    .foregroundColor(locationService.isTracking ? Color.zuluYellow : .gray)

                Text("GPS Location")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.zuluYellow)

                Spacer()
            }

            // Data rows
            LocationRow(label: "Latitude:", value: locationService.latitude)
            LocationRow(label: "Longitude:", value: locationService.longitude)
            LocationRow(label: "Altitude:", value: locationService.altitude)
            LocationRow(label: "Accuracy:", value: locationService.accuracy)

            // Status
            Text(locationService.statusMessage)
                .font(.system(size: 14))
                .italic()
                .foregroundColor(.white.opacity(0.54))
        }
        .padding(20)
        .background(Color(white: 0.11))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.zuluYellow, lineWidth: 2)
        )
    }
}

// MARK: - Location Row

struct LocationRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Color Extension

extension Color {
    static let zuluYellow = Color(red: 1.0, green: 0.922, blue: 0.231) // #FFEB3B
}

#Preview {
    ContentView()
}
