# App Store Screenshot Guide

## Required Screenshot Sizes

Apple requires screenshots for at least one device size. Best practice is to provide all sizes.

### Required (Choose One)
- **6.7" Display** (iPhone 14 Pro Max, 15 Pro Max) - 1290 x 2796 px
- **6.5" Display** (iPhone 11 Pro Max, XS Max) - 1242 x 2688 px

### Recommended Additional Sizes
- **5.5" Display** (iPhone 8 Plus) - 1242 x 2208 px
- **iPad Pro (12.9")** - 2048 x 2732 px (if supporting iPad)

## How to Capture Screenshots

### Method 1: iOS Simulator (Mac Required)

1. **Open iOS Simulator** (comes with Xcode)
2. **Select device**: iPhone 15 Pro Max
3. **Run your app**: `flutter run`
4. **Capture screenshot**: 
   - Cmd + S (saves to Desktop)
   - Or: Device → Screenshot

### Method 2: Physical Device

1. **Run app on physical iPhone**
2. **Take screenshot**: Press Side Button + Volume Up
3. **Transfer to computer** via AirDrop or iCloud Photos
4. **Resize if needed** to exact pixel dimensions

### Method 3: Screenshot Generator Tools

Use tools like:
- **fastlane snapshot** - Automated screenshot generation
- **App Store Screenshot Generator** (online tools)

## Screenshot Content Guidelines

### What to Show

**Screenshot 1: Main Screen**
- Full time display (UTC + Local)
- GPS section visible
- Clean, professional look

**Screenshot 2: GPS Active**
- GPS tracking enabled (green icon)
- Coordinates populated
- Altitude and accuracy showing

**Screenshot 3: Permission Dialog** (Optional)
- Show the location permission prompt
- Demonstrates privacy transparency

**Screenshot 4: Portrait + Landscape** (If supported)
- Different orientations
- Shows versatility

### Apple's Requirements

✅ **DO:**
- Use actual app screenshots
- Show real functionality
- Keep UI clean and readable
- Use high-quality images
- Show app in action

❌ **DON'T:**
- Mock up fake screenshots
- Include device frames (Apple adds them)
- Add promotional text overlays
- Use outdated iOS versions
- Show placeholder content

## Example Screenshot Layout

```
┌─────────────────────┐
│                     │
│    ZuluTime         │  ← App header
│                     │
│       UTC           │
│   22:00:56          │  ← Large time display
│   2026-02-08        │
│                     │
│      Local          │
│   17:00:56          │  ← Local time
│   2026-02-08        │
│      -0500          │
│                     │
│  ┌───────────────┐  │
│  │ 📍 GPS Location│  │  ← GPS section
│  │ 28.615889° N, │  │
│  │ 80.847417° W  │  │
│  │ Alt: 5.2 m    │  │
│  │ Acc: ±8.3 m   │  │
│  └───────────────┘  │
│                     │
└─────────────────────┘
```

## Screenshot Checklist

- [ ] All text is readable
- [ ] GPS shows realistic coordinates
- [ ] Time is formatted correctly
- [ ] No placeholder data visible
- [ ] Status bar looks clean
- [ ] Dark mode looks good (if supported)
- [ ] No personal information visible
- [ ] Image dimensions are exact

## Naming Convention

Organize your screenshots:
```
screenshots/
├── iphone_6.7/
│   ├── 1_main_screen.png
│   ├── 2_gps_active.png
│   └── 3_permissions.png
├── iphone_6.5/
│   ├── 1_main_screen.png
│   ├── 2_gps_active.png
│   └── 3_permissions.png
└── ipad_12.9/
    └── ...
```

## Upload to App Store Connect

1. **Go to App Store Connect**
2. **Select your app**
3. **Go to App Store tab**
4. **Scroll to Media Manager**
5. **Drag and drop screenshots**
6. **Organize in desired order**

### Screenshot Order Matters

The first screenshot is the most important - it appears in search results.

**Recommended Order:**
1. Main screen with time display
2. GPS data showing
3. Feature highlights
4. Additional views

## Testing Before Submission

### Check on Different Displays

View your screenshots on:
- [ ] Retina displays
- [ ] Non-retina displays  
- [ ] Different lighting conditions
- [ ] Light mode vs Dark mode

### Peer Review

Have someone else review:
- Is the purpose clear?
- Does it look professional?
- Would you download this app?
- Any typos or errors visible?

## Optional: App Preview Video

You can also create a 30-second app preview video showing:
1. App launch
2. Time updating in real-time
3. Enabling GPS
4. Coordinates appearing
5. Key features demo

**Requirements:**
- 30 seconds max
- Same aspect ratios as screenshots
- No audio required (but can include)
- Must show actual app functionality

## Tools for Creating Screenshots

### Free
- iOS Simulator (Mac)
- Device screenshots
- GIMP (image editing)

### Paid
- **Sketch** - Design tool
- **Figma** - Design tool
- **Adobe Photoshop** - Image editing
- **fastlane** - Automation ($0 but requires Mac)

### Online Services
- **App Screenshot Generator** websites
- **Canva** (free tier available)
- **Mockup generators**

## Pro Tips

1. **Use realistic data**: Don't show 00:00:00 or 12:34:56
2. **Show your location** (if not sensitive): Real coordinates look better
3. **Consistent styling**: Keep all screenshots in same style
4. **Highlight unique features**: GPS + UTC time combo
5. **Update regularly**: Refresh screenshots with app updates

## Common Mistakes to Avoid

❌ Screenshots too dark/light
❌ Text too small to read
❌ Cluttered interface
❌ Outdated iOS version showing
❌ Personal/sensitive data visible
❌ Wrong aspect ratios
❌ Low resolution images
❌ Device frames included (Apple adds them)

## Sample Schedule

**Day 1**: Create mockups and plan screenshots
**Day 2**: Capture screenshots from simulator/device  
**Day 3**: Edit and optimize images
**Day 4**: Get peer feedback
**Day 5**: Upload to App Store Connect

## Resources

- [Apple Screenshot Specifications](https://help.apple.com/app-store-connect/#/devd274dd925)
- [iOS Design Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

**Final Check Before Upload:**
- ✅ Correct dimensions
- ✅ Professional appearance
- ✅ Accurate representation
- ✅ No personal data
- ✅ Meets Apple guidelines
