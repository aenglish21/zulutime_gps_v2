# ZuluTime GPS - Project Structure

```
zulutime_gps/
│
├── lib/                                    # Main application code
│   ├── main.dart                          # App entry point, providers setup
│   ├── screens/
│   │   └── time_display_screen.dart       # Main UI screen with time & GPS
│   ├── services/
│   │   ├── time_service.dart             # UTC/Local time management
│   │   └── location_service.dart         # GPS location tracking
│   └── widgets/                           # Reusable UI components
│       ├── time_display.dart             # Time display widget
│       └── location_display.dart         # GPS display widget
│
├── android/                               # Android-specific configuration
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml   # Android permissions & config
│
├── ios/                                   # iOS-specific configuration
│   └── Runner/
│       └── Info.plist                    # iOS permissions & config
│
├── pubspec.yaml                          # Flutter dependencies
├── codemagic.yaml                        # CI/CD configuration for builds
├── .gitignore                            # Git ignore patterns
│
├── README.md                             # Main project documentation
├── QUICKSTART.md                         # Quick start guide
├── DEPLOYMENT_CHECKLIST.md               # Step-by-step deployment guide
└── PROJECT_STRUCTURE.md                  # This file
```

## Key Files Explained

### Application Code

**lib/main.dart**
- App entry point
- Sets up Provider state management
- Configures app theme and routing
- Forces portrait orientation

**lib/services/time_service.dart**
- Manages time updates (every second)
- Provides UTC and local time
- Calculates timezone offsets
- Uses ChangeNotifier for reactive updates

**lib/services/location_service.dart**
- Handles GPS permissions
- Tracks device location
- Provides coordinates, altitude, accuracy
- Supports continuous tracking mode

**lib/screens/time_display_screen.dart**
- Main application UI
- Displays UTC time (large)
- Displays local time (large)
- Shows GPS location in yellow-bordered card
- Handles permission requests

### Configuration Files

**pubspec.yaml**
- Project metadata
- Flutter dependencies:
  - `intl` - Date/time formatting
  - `timezone` - Timezone handling
  - `geolocator` - GPS location
  - `permission_handler` - Permissions
  - `provider` - State management

**android/app/src/main/AndroidManifest.xml**
- Android app configuration
- Location permissions:
  - `ACCESS_FINE_LOCATION` - Precise GPS
  - `ACCESS_COARSE_LOCATION` - Approximate location
  - `ACCESS_BACKGROUND_LOCATION` - Background tracking

**ios/Runner/Info.plist**
- iOS app configuration
- Location permissions with user-facing descriptions:
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocationAlwaysAndWhenInUseUsageDescription`
  - `NSLocationAlwaysUsageDescription`
- Background modes for location tracking

**codemagic.yaml**
- Automated build configuration
- iOS workflow for App Store builds
- Android workflow for APK/AAB builds
- Publishing settings for TestFlight

## Data Flow

```
User Opens App
     ↓
main.dart initializes
     ↓
Providers created:
  - TimeService (starts 1s timer)
  - LocationService (inactive)
     ↓
TimeDisplayScreen loads
     ↓
Requests location permission
     ↓
LocationService.startTracking()
     ↓
GPS coordinates acquired
     ↓
UI updates via Provider listeners:
  - Time updates every second
  - Location updates every 10 meters
```

## State Management

**Provider Pattern:**
- `ChangeNotifier` classes notify listeners of changes
- `Consumer` widgets rebuild when data changes
- Efficient updates (only affected widgets rebuild)

**TimeService:**
- Notifies every second
- Provides formatted time strings
- Calculates timezone offsets

**LocationService:**
- Notifies on location updates
- Provides formatted coordinates
- Manages permission states

## Build Outputs

### Local Development (Windows)
- `flutter run` → Android APK installed to device/emulator
- `flutter run -d chrome` → Web version for UI testing
- `flutter build apk` → Release APK

### Cloud Builds (Codemagic/GitHub Actions)
- `flutter build ipa` → iOS App Store IPA
- `flutter build appbundle` → Android App Bundle (Google Play)

## Dependencies Breakdown

| Package | Version | Purpose |
|---------|---------|---------|
| `intl` | ^0.19.0 | Date/time formatting |
| `timezone` | ^0.9.3 | Timezone calculations |
| `geolocator` | ^11.0.0 | GPS location access |
| `permission_handler` | ^11.3.0 | Permission management |
| `provider` | ^6.1.0 | State management |

## Development Workflow

1. **Local Development**
   - Edit code on Windows
   - Test on Android emulator
   - Hot reload for instant updates
   - Debug with breakpoints

2. **Git Workflow**
   - Commit changes to Git
   - Push to GitHub/GitLab
   - Triggers cloud build (if configured)

3. **Cloud Build**
   - Codemagic detects push
   - Runs iOS/Android builds
   - Generates IPA/APK
   - Uploads to TestFlight/App Store

4. **Testing**
   - TestFlight for iOS testers
   - Internal testing for Android
   - Collect feedback
   - Iterate

## Customization Points

**Branding:**
- Colors: `main.dart` and `time_display_screen.dart`
- App name: `pubspec.yaml`, `Info.plist`, `AndroidManifest.xml`
- Bundle ID: `Info.plist` (iOS) and `build.gradle` (Android)

**Features:**
- Add widgets to `lib/widgets/`
- Add screens to `lib/screens/`
- Add services to `lib/services/`

**Permissions:**
- Modify `Info.plist` for iOS
- Modify `AndroidManifest.xml` for Android

## Testing Strategy

1. **Unit Tests** - Test individual services
2. **Widget Tests** - Test UI components
3. **Integration Tests** - Test app flow
4. **Manual Testing** - Test on physical devices

## Performance Considerations

- Time updates: Every 1 second (minimal CPU impact)
- GPS updates: Every 10 meters (battery efficient)
- UI rebuilds: Only affected widgets via Provider
- Background tracking: Optional (user controlled)

## Security Notes

- Never commit certificates or private keys
- Use environment variables for secrets
- Keep `.gitignore` updated
- Use encrypted secrets in CI/CD
- Store API keys securely in Codemagic

## Future Enhancements

Potential additions to structure:

```
lib/
├── models/              # Data models
│   ├── waypoint.dart
│   └── location_log.dart
├── utils/               # Helper functions
│   ├── grid_converter.dart
│   └── astronomy.dart
├── constants/           # App constants
│   └── colors.dart
└── config/              # Configuration
    └── app_config.dart
```

## File Sizes (Approximate)

- Source code: ~50 KB
- Dependencies: ~100 MB (with Flutter SDK)
- Android APK: ~20-30 MB
- iOS IPA: ~40-50 MB
- Project total: ~150 MB (including build artifacts)

## Version Control

**Ignored by Git:**
- Build artifacts (`/build/`)
- Generated files (`.dart_tool/`, `.packages`)
- IDE files (`.idea/`, `.vscode/`)
- Platform builds (`android/app/release`, `ios/DerivedData/`)
- Sensitive files (`*.p12`, `*.mobileprovision`)

**Tracked by Git:**
- Source code (`lib/`, `test/`)
- Configuration (`pubspec.yaml`, manifests)
- Documentation (README, guides)
- Assets (icons, images)

---

*This structure follows Flutter best practices and CAP IT standards.*
