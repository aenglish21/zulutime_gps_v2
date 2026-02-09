# Quick Start Guide

## For Windows Development

### 1. Initial Setup (5 minutes)

```bash
# Verify Flutter is installed
flutter --version

# Navigate to project
cd zulutime_gps

# Install dependencies
flutter pub get

# Check setup
flutter doctor
```

### 2. Test on Android (Fastest way to see it working)

```bash
# List available devices/emulators
flutter devices

# Run on Android emulator
flutter run

# Or run on connected Android phone (enable USB debugging)
flutter run
```

### 3. Test Location Features

**Android Emulator GPS Simulation:**
1. Open emulator Extended Controls (... button)
2. Go to Location tab
3. Set coordinates manually or use search
4. Click "Send" to update location

**Physical Device:**
- Enable location services
- Grant app permissions when prompted
- Go outdoors for best GPS accuracy

## For iOS Deployment

### Option A: Codemagic (Easiest)

1. **Create account**: https://codemagic.io/signup
2. **Connect GitHub repo**:
   - Push your code to GitHub
   - Connect repository in Codemagic
3. **Configure workflow**: Use `codemagic.yaml` (included)
4. **Add certificates**:
   - Upload Apple Developer certificates
   - Add provisioning profiles
5. **Build**: Click "Start new build"

### Option B: GitHub Actions

1. **Push to GitHub**
2. **Enable GitHub Actions** in repository settings
3. **Add secrets**:
   - `APPLE_CERTIFICATE`: Your signing certificate
   - `APPLE_CERTIFICATE_PASSWORD`: Certificate password
   - `PROVISIONING_PROFILE`: Your provisioning profile
4. **Push to trigger build**

## Apple Developer Setup

### Required Steps

1. **Join Apple Developer Program**
   - Cost: $99/year
   - Sign up: https://developer.apple.com/programs/

2. **Create App ID**
   - Go to: https://developer.apple.com/account
   - Identifiers → App IDs → Register
   - Bundle ID: `com.yourcompany.zulutime_gps`
   - Enable: Location services

3. **Create Certificates**
   - Certificates → Production → App Store
   - Download and save certificate

4. **Create Provisioning Profile**
   - Profiles → Distribution → App Store
   - Link to your App ID
   - Download profile

## Recommended Development Flow

### Week 1: Core Development (Windows)
- Develop UI on Android emulator
- Test GPS features on Android device
- Refine layouts and functionality
- Test with different locations

### Week 2: iOS Build Setup
- Create Apple Developer account
- Set up Codemagic account
- Generate certificates and profiles
- Connect GitHub repository

### Week 3: iOS Testing
- Build IPA via Codemagic
- Upload to TestFlight
- Test on physical iPhone
- Fix iOS-specific issues

### Week 4: Polish & Release
- Final testing on both platforms
- App Store screenshots
- Write App Store description
- Submit for review

## Common Issues

### "GPS not working"
- ✅ Check location services enabled
- ✅ Grant app permissions
- ✅ Try outdoors for better signal
- ✅ Restart app if needed

### "Flutter not found"
- ✅ Add Flutter to Windows PATH
- ✅ Restart terminal/IDE
- ✅ Run `flutter doctor`

### "No devices found"
- ✅ Start Android emulator
- ✅ Enable USB debugging on phone
- ✅ Install device drivers (Android)

### "Pod install fails" (iOS build)
- ✅ Run `pod repo update` on Mac
- ✅ Clear CocoaPods cache
- ✅ Check Xcode version compatibility

## File You'll Need to Customize

Before production deployment, update:

1. **Bundle Identifier** (iOS)
   - Edit when you have Mac access
   - Format: `com.yourcompany.zulutime_gps`

2. **Application ID** (Android)
   - In `android/app/build.gradle`
   - Change `applicationId "com.example.zulutime_gps"`

3. **App Name**
   - iOS: `ios/Runner/Info.plist` → `CFBundleDisplayName`
   - Android: `android/app/src/main/AndroidManifest.xml` → `android:label`

4. **App Icon**
   - Add icon to `assets/icon.png`
   - Run: `flutter pub run flutter_launcher_icons`

## Support Resources

- **Flutter Docs**: https://docs.flutter.dev
- **Codemagic Docs**: https://docs.codemagic.io
- **Apple Developer**: https://developer.apple.com/support
- **Stack Overflow**: Tag `flutter` for questions

## Next Steps After Setup

1. Customize colors/branding
2. Add app icon (1024x1024 PNG)
3. Test on multiple devices
4. Add analytics (optional)
5. Implement crash reporting (optional)
6. Create App Store assets (screenshots, description)

## Estimated Timeline

- **Local Development**: Immediate
- **Android Testing**: Same day
- **Apple Developer Account**: 1-2 days (approval)
- **First iOS Build**: 1-2 days (setup)
- **TestFlight Testing**: Same day after build
- **App Store Submission**: 1-7 days (review)

Good luck! 🚀
