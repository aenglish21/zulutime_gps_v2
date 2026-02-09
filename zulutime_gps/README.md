# ZuluTime GPS

A Flutter app that displays UTC (Zulu) time alongside local time with integrated GPS location tracking. Perfect for aviation, CAP operations, and coordinating across timezones.

## Features

- **UTC/Zulu Time Display** - Large, easy-to-read UTC time
- **Local Time Display** - Current local time with timezone offset
- **GPS Location Tracking** - Real-time coordinates, altitude, and accuracy
- **Clean UI** - Black background with yellow accents (aviation-inspired)
- **Auto-updating** - Times update every second
- **Location Permissions** - Proper iOS and Android permission handling

## Development Setup (Windows)

### Prerequisites

1. **Install Flutter SDK**
   - Download from: https://flutter.dev/docs/get-started/install/windows
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **Install Visual Studio Code**
   - Install Flutter extension
   - Install Dart extension

3. **Install Git**
   - Download from: https://git-scm.com/download/win

### Local Development

```bash
# Navigate to project directory
cd zulutime_gps

# Get dependencies
flutter pub get

# Run on Android emulator or connected device
flutter run

# Run on web (for testing UI)
flutter run -d chrome

# Check for issues
flutter doctor
```

## iOS Deployment (Cloud Build)

Since you're on Windows, you'll need a cloud macOS build service for iOS.

### Option 1: Codemagic (Recommended)

1. **Sign up at**: https://codemagic.io
2. **Connect your Git repository**
3. **Configure build settings**:
   ```yaml
   workflows:
     ios-workflow:
       name: iOS Workflow
       max_build_duration: 60
       environment:
         flutter: stable
         xcode: latest
         cocoapods: default
       scripts:
         - flutter pub get
         - flutter build ios --release --no-codesign
       artifacts:
         - build/ios/ipa/*.ipa
   ```

### Option 2: GitHub Actions

1. **Create `.github/workflows/ios.yml`**:
   ```yaml
   name: iOS Build
   on: [push]
   jobs:
     build:
       runs-on: macos-latest
       steps:
         - uses: actions/checkout@v3
         - uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.x'
         - run: flutter pub get
         - run: flutter build ios --release --no-codesign
   ```

### Option 3: AWS Mac Instances

- https://aws.amazon.com/ec2/instance-types/mac/
- Direct remote access to macOS
- More control but more expensive

## Apple Developer Account Setup

### Requirements

1. **Apple Developer Account** - $99/year
   - Sign up at: https://developer.apple.com

2. **App Store Connect Setup**
   - Create App ID: `com.yourcompany.zulutime_gps`
   - Create provisioning profiles
   - Generate certificates

### Update Bundle Identifier

Edit `ios/Runner.xcodeproj/project.pbxproj` (when you have Mac access):
```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.zulutime_gps;
```

## Testing Strategy

### On Windows (During Development)

- ✅ **Android Emulator** - Full testing of all features
- ✅ **Web Browser** - UI testing (limited GPS simulation)
- ✅ **Physical Android Device** - Real GPS testing

### For iOS Testing

- Use cloud build service to generate IPA
- Install via TestFlight
- Distribute to beta testers

## App Permissions

### iOS (already configured)
- `NSLocationWhenInUseUsageDescription` - Location access
- `NSLocationAlwaysAndWhenInUseUsageDescription` - Background location
- `UIBackgroundModes` - Location tracking

### Android (already configured)
- `ACCESS_FINE_LOCATION` - Precise GPS
- `ACCESS_COARSE_LOCATION` - Approximate location
- `ACCESS_BACKGROUND_LOCATION` - Background tracking (API 29+)

## Project Structure

```
zulutime_gps/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   └── time_display_screen.dart # Main UI screen
│   ├── services/
│   │   ├── time_service.dart        # UTC/local time logic
│   │   └── location_service.dart    # GPS functionality
│   └── widgets/                     # (Future custom widgets)
├── ios/
│   └── Runner/
│       └── Info.plist               # iOS permissions
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml # Android permissions
└── pubspec.yaml                     # Dependencies
```

## Next Steps

1. **Test on Android emulator** locally
2. **Set up cloud build service** (Codemagic recommended)
3. **Create Apple Developer account**
4. **Configure signing certificates**
5. **Build and deploy to TestFlight**
6. **Submit to App Store**

## Future Enhancements

- [ ] Location history/logging
- [ ] Sunrise/sunset times
- [ ] MGRS/USNG grid coordinates
- [ ] Custom waypoints
- [ ] Dark/light theme toggle
- [ ] Altitude graph
- [ ] Speed tracking
- [ ] Distance calculator

## Troubleshooting

### Location Not Working

- Check device location services are enabled
- Verify app has location permissions
- Ensure GPS hardware is available
- Try outdoors for better GPS signal

### Build Issues

```bash
# Clean build cache
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade

# Check Flutter installation
flutter doctor -v
```

## License

MIT License - Feel free to use and modify for your needs.

## Credits

Inspired by the original ZuluTime app, rebuilt with GPS capabilities for CAP operations and aviation use.
