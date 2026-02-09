import SwiftUI

struct ContentView: View {
    @StateObject private var timeService = TimeService()
    @StateObject private var locationService = LocationService()
    @AppStorage("showGPS") private var showGPS = true
    @AppStorage("useFeet") private var useFeet = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // --- UTC Time ---
                    VStack(spacing: 8) {
                        Text("UTC")
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(.white)

                        Text(timeService.utcTimeFormatted)
                            .font(.system(size: 72, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        Text(timeService.utcDateFormatted)
                            .font(.system(size: 24, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 24)

                    Spacer().frame(height: 48)

                    // --- Local Time ---
                    VStack(spacing: 8) {
                        Text("Local")
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(.white)

                        Text(timeService.localTimeFormatted)
                            .font(.system(size: 72, weight: .bold, design: .monospaced))
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
                    if showGPS {
                        GPSCardView(locationService: locationService, useFeet: useFeet)
                    }
                }
                .padding(.horizontal, 24)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("ZuluTime")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.zuluYellow)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        locationService.refreshLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showSettings) {
                SettingsView(showGPS: $showGPS, useFeet: $useFeet)
            }
        }
        .onAppear {
            locationService.startTracking()
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Binding var showGPS: Bool
    @Binding var useFeet: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("GPS Display") {
                    Toggle("Show GPS Location", isOn: $showGPS)
                }

                Section("Units") {
                    Picker("Altitude / Accuracy", selection: $useFeet) {
                        Text("Meters").tag(false)
                        Text("Feet").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - GPS Card

struct GPSCardView: View {
    @ObservedObject var locationService: LocationService
    var useFeet: Bool

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

            // CAP Grid reference
            LocationRow(label: "CAP Grid:", value: locationService.capGrid)

            Divider().background(Color.zuluYellow.opacity(0.3))

            // Data rows
            LocationRow(label: "Latitude:", value: locationService.latitude)
            LocationRow(label: "Longitude:", value: locationService.longitude)
            LocationRow(label: "Altitude:", value: locationService.altitude(useFeet: useFeet))
            LocationRow(label: "Accuracy:", value: locationService.accuracy(useFeet: useFeet))

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
