import SwiftUI

struct ContentView: View {
    @StateObject private var timeService = TimeService()
    @StateObject private var locationService = LocationService()
    @AppStorage("gpsEnabled") private var gpsEnabled = true
    @AppStorage("useFeet") private var useFeet = false
    @AppStorage("keepScreenOn") private var keepScreenOn = true
    @State private var showingSettings = false

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
                    if gpsEnabled {
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
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel("Settings")
                }
                ToolbarItem(placement: .principal) {
                    Text("Zulu Time")
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
                    .accessibilityLabel("Refresh Location")
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showingSettings) {
                SettingsView(gpsEnabled: $gpsEnabled, useFeet: $useFeet, keepScreenOn: $keepScreenOn)
            }
        }
        .onAppear {
            if gpsEnabled {
                locationService.startTracking()
            }
            UIApplication.shared.isIdleTimerDisabled = keepScreenOn
        }
        .onChange(of: gpsEnabled) { enabled in
            if enabled {
                locationService.startTracking()
            } else {
                locationService.stopTracking()
            }
        }
        .onChange(of: keepScreenOn) { enabled in
            UIApplication.shared.isIdleTimerDisabled = enabled
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Binding var gpsEnabled: Bool
    @Binding var useFeet: Bool
    @Binding var keepScreenOn: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var showReportAlert = false
    @State private var gridInput = ""
    @State private var noteInput = ""
    @State private var isSubmitting = false
    @State private var showFeedback = false
    @State private var feedbackMessage = ""
    @State private var feedbackIsError = false

    var body: some View {
        NavigationStack {
            List {
                Section("Display") {
                    Toggle("Keep Screen On", isOn: $keepScreenOn)
                }

                Section("GPS") {
                    Toggle("GPS Tracking", isOn: $gpsEnabled)
                }

                Section("Units") {
                    Picker("Altitude / Accuracy", selection: $useFeet) {
                        Text("Meters").tag(false)
                        Text("Feet").tag(true)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Support") {
                    Button(action: { showReportAlert = true }) {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                            Text("Report CAP Grid Issue")
                        }
                        .foregroundColor(.red)
                    }
                    .disabled(isSubmitting)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Report CAP Grid Issue", isPresented: $showReportAlert) {
                TextField("Grid (e.g., B7)", text: $gridInput)
                TextField("Description (optional)", text: $noteInput)

                Button("Cancel", role: .cancel) {
                    gridInput = ""
                    noteInput = ""
                }

                Button("Report", action: {
                    if !gridInput.isEmpty {
                        Task {
                            await reportGridIssue(grid: gridInput, note: noteInput)
                        }
                    }
                })
                .disabled(gridInput.isEmpty || isSubmitting)
            }
            .alert("Report Status", isPresented: $showFeedback) {
                Button("OK") { }
            } message: {
                Text(feedbackMessage)
            }
        }
    }

    private func reportGridIssue(grid: String, note: String) async {
        isSubmitting = true

        let url = URL(string: "https://gridapi.addisonserver.com/report-error")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

        let payload: [String: Any] = [
            "grid": grid,
            "note": note.isEmpty ? NSNull() : note,
            "device_id": deviceId,
            "app_version": appVersion
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)

            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                feedbackMessage = "Issue reported successfully!"
                feedbackIsError = false
                gridInput = ""
                noteInput = ""
            } else {
                feedbackMessage = "Failed to report issue. Please try again."
                feedbackIsError = true
            }
        } catch {
            feedbackMessage = "Error: \(error.localizedDescription)"
            feedbackIsError = true
        }

        showReportAlert = false
        showFeedback = true
        isSubmitting = false
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
