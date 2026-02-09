# ZuluTime GPS - Features & Architecture

## App Features

### Core Features (from original app)
✅ Large UTC (Zulu) time display
✅ Local time display
✅ Date display for both times
✅ Timezone offset indicator
✅ Clean, high-contrast UI (black/yellow/white)
✅ Real-time updates (10x per second for smooth display)

### Enhanced GPS Features (new)
✅ GPS coordinate display (lat/long)
✅ Altitude measurement
✅ Location accuracy indicator
✅ Play/pause GPS tracking
✅ Manual location refresh
✅ Real-time position updates
✅ Background location capability (iOS)

### Technical Features
✅ Provider state management
✅ Responsive UI design
✅ iOS and Android support
✅ Permission handling
✅ Error handling for GPS failures
✅ Battery-efficient location tracking

## Architecture

### Layer Structure
```
Presentation Layer (UI)
├── Screens
│   └── TimeDisplayScreen (main screen)
└── Widgets
    ├── TimeDisplay (UTC/Local time component)
    └── LocationDisplay (GPS info component)

Business Logic Layer
├── Services
│   ├── TimeService (time calculations)
│   └── LocationService (GPS management)
└── State Management (Provider)

Platform Layer
├── iOS Platform (location permissions, GPS)
├── Android Platform (location permissions, GPS)
└── Flutter Framework
```

### State Management Flow
```
User Action → Service → notifyListeners() → UI Updates
     ↓
LocationService.startTracking()
     ↓
Geolocator Stream → Position Updates
     ↓
UI automatically rebuilds via Consumer<LocationService>
```

### Data Flow
```
TimeService:
  Timer (100ms) → DateTime.now() → UTC/Local conversion → UI

LocationService:
  Permission Check → GPS Stream → Position Updates → UI
```

## Technical Specifications

### Time Display
- **Update Frequency**: 10Hz (100ms intervals)
- **Format**: HH:mm:ss (24-hour)
- **Date Format**: yyyy-MM-dd (ISO 8601)
- **Timezone**: Automatic detection with offset display

### GPS Tracking
- **Accuracy**: High (uses GPS + WiFi + cellular)
- **Update Distance**: 10 meters
- **Coordinate Precision**: 6 decimal places (~0.1 meter accuracy)
- **Altitude**: Meters above sea level
- **Permissions**: When-in-use + Always (iOS)

### Performance
- **Battery Impact**: Low (location updates only when needed)
- **Memory**: Minimal (single screen, efficient state)
- **UI Thread**: Never blocked (async GPS operations)

## Use Cases

### Primary Users
1. **Pilots**: UTC time reference + GPS coordinates
2. **CAP Members**: Mission coordination with Zulu time
3. **Ham Radio Operators**: UTC logging + grid references
4. **Mariners**: Navigation time + position
5. **International Teams**: Timezone coordination

### Scenarios
- Flight planning with UTC reference
- Emergency position reporting
- Scientific observations with timestamp
- Event coordination across timezones
- GPS waypoint recording

## Future Enhancement Ideas

### High Priority
- [ ] MGRS/USNG grid coordinate conversion
- [ ] Sunrise/sunset calculator based on GPS
- [ ] Waypoint logging with timestamps
- [ ] Export coordinates to CSV/KML

### Medium Priority
- [ ] Multiple timezone displays
- [ ] Compass heading
- [ ] Speed and bearing
- [ ] Location history with map
- [ ] Configurable coordinate formats (DMS, DDM)

### Low Priority
- [ ] Theme customization
- [ ] Widget for home screen
- [ ] Apple Watch companion app
- [ ] Siri shortcuts

## Comparison with Original

| Feature | Original ZuluTime | This Version |
|---------|------------------|--------------|
| UTC Time | ✅ | ✅ |
| Local Time | ✅ | ✅ |
| Date Display | ✅ | ✅ |
| Timezone Offset | ✅ | ✅ |
| GPS Coordinates | ❌ | ✅ |
| Altitude | ❌ | ✅ |
| Location Tracking | ❌ | ✅ |
| Accuracy Display | ❌ | ✅ |
| Platform | iOS only | iOS + Android |
| Open Source | ❌ | ✅ |

## Dependencies Analysis

### Core Dependencies
- `flutter` - UI framework
- `provider` (6.1.1) - State management
  - Why: Simple, efficient, official recommendation
  - Alternatives: Riverpod, Bloc, GetX

### Time Dependencies
- `intl` (0.19.0) - Date formatting
  - Why: Standard Flutter package, reliable
- `timezone` (0.9.2) - Timezone handling
  - Why: Comprehensive timezone database

### Location Dependencies
- `geolocator` (11.0.0) - GPS services
  - Why: Most popular, well-maintained
  - Features: Streams, permissions, distance calculations
- `permission_handler` (11.3.0) - Runtime permissions
  - Why: Cross-platform permission handling

### Why These Choices?
1. **Mature packages** - Long track record
2. **Active maintenance** - Regular updates
3. **Good documentation** - Easy to debug
4. **Community support** - Stack Overflow answers
5. **Null safety** - Modern Dart

## Code Quality

### Best Practices Implemented
✅ Null safety throughout
✅ Const constructors for performance
✅ Proper resource disposal (Timer, streams)
✅ Error handling for GPS failures
✅ Permission checks before GPS access
✅ Responsive design principles
✅ Separation of concerns (Services vs UI)

### Code Organization
- **Services**: Business logic only, no UI
- **Widgets**: Reusable UI components
- **Screens**: Screen-level composition
- **Main**: App initialization only

## Development Workflow

### On Windows
1. Code changes in VS Code
2. Test on Android emulator
3. Git commit and push
4. CI/CD builds iOS automatically

### Testing Strategy
- **Android**: Primary development testing
- **Web**: Quick UI checks (limited GPS)
- **iOS**: Final testing via TestFlight

### Build Process
```
Windows Dev → Git Push → CI/CD (Mac) → iOS Build → TestFlight → App Store
```

## App Size Estimate

**Release Build:**
- iOS: ~15-20 MB (Flutter + dependencies)
- Android: ~18-25 MB (with split APKs)

**Download Size (App Store):**
- ~10-12 MB (compressed)

## Requirements

### Minimum iOS Version
- iOS 12.0+ (recommended: iOS 13+)
- Reason: GPS and permission APIs

### Minimum Android Version
- Android 6.0 (API 23)
- Reason: Runtime permissions model

### Device Requirements
- GPS hardware (all modern phones)
- Internet for initial timezone data
- Location services enabled

## Security & Privacy

### Data Collection
- ❌ No analytics
- ❌ No crash reporting (in this version)
- ❌ No user accounts
- ✅ GPS data stays on device only

### Permissions Used
- Location (When-in-use): For GPS display
- Location (Always): Optional, for background updates

### Privacy Policy
App does not collect, transmit, or store any user data.
Location is used only for display purposes.

---

**Build Date**: February 2026
**Flutter Version**: 3.x
**Target Platforms**: iOS 12+, Android 6+
