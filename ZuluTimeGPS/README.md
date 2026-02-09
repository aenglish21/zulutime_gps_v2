# ZuluTime GPS - Native iOS App

A native iOS app for displaying UTC (Zulu) time with integrated GPS location tracking. Built with Swift and SwiftUI for Xcode — no Flutter or cross-platform dependencies.

## Features

- **UTC (Zulu) Time** — Large, readable 24-hour time display updated every second
- **Local Time** — Device local time with timezone offset indicator
- **ISO 8601 Dates** — yyyy-MM-dd format for both UTC and local
- **GPS Tracking** — Real-time coordinates (6 decimal precision), altitude, and accuracy
- **Continuous Updates** — Location streaming with 10-meter distance filter
- **Background Location** — Supports background location updates for mission logging
- **Aviation-Inspired UI** — Black background, yellow accents, high-contrast monospace fonts

## Target Users

- Pilots and aviation professionals
- Civil Air Patrol (CAP) members
- Ham radio operators
- International teams coordinating across timezones

## Requirements

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+
- No third-party dependencies (uses only Apple frameworks: SwiftUI, CoreLocation, Combine)

## Getting Started

1. Open `ZuluTimeGPS.xcodeproj` in Xcode
2. Select your development team under **Signing & Capabilities**
3. Update the **Bundle Identifier** if needed (default: `com.zulutime.gps`)
4. Build and run on a device or simulator

> **Note:** GPS features require a physical device. The simulator will return a fixed location.

## Project Structure

```
ZuluTimeGPS/
├── ZuluTimeGPS.xcodeproj/       # Xcode project file
└── ZuluTimeGPS/
    ├── ZuluTimeGPSApp.swift     # App entry point
    ├── ContentView.swift        # Main UI (time display + GPS card)
    ├── Services/
    │   ├── TimeService.swift    # UTC/local time management (1-second timer)
    │   └── LocationService.swift # CoreLocation GPS tracking
    ├── Info.plist               # Location permissions & background modes
    ├── Assets.xcassets/         # App icon & accent color
    └── Preview Content/         # SwiftUI preview assets
```

## Architecture

- **SwiftUI** declarative UI with `@StateObject` / `@ObservedObject`
- **TimeService** — `ObservableObject` using Combine `Timer.publish` for 1-second updates
- **LocationService** — `ObservableObject` wrapping `CLLocationManager` with delegate pattern
- No third-party packages — zero dependency footprint

## Permissions

The app requests these location permissions (configured in Info.plist):

| Permission | Description |
|---|---|
| When In Use | Display coordinates and timezone info |
| Always | Track coordinates during missions |
| Background Mode | Continue tracking when app is backgrounded |

## Customization

- **Bundle ID**: Change `PRODUCT_BUNDLE_IDENTIFIER` in project settings
- **App Icon**: Add a 1024x1024 PNG to `Assets.xcassets/AppIcon.appiconset/`
- **Deployment Target**: Currently iOS 16.0, adjustable in project settings

## Building for Release

1. Set your **Team** and **Bundle Identifier** in Xcode
2. Select **Product > Archive**
3. Upload to App Store Connect via the Organizer
4. Submit for TestFlight / App Store review
