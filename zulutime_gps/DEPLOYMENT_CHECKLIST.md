# iOS App Store Deployment Checklist

## Pre-Deployment (Windows)

### 1. Code Complete ✓
- [ ] All features tested on Android
- [ ] GPS tracking works reliably
- [ ] UI matches design specifications
- [ ] No crashes or critical bugs
- [ ] Performance is acceptable

### 2. Customization ✓
- [ ] Update Bundle ID in all files
- [ ] Change app name if desired
- [ ] Add custom app icon (1024x1024 PNG)
- [ ] Update colors/branding if needed
- [ ] Set version number in `pubspec.yaml`

### 3. Git Repository Setup ✓
- [ ] Create GitHub/GitLab repository
- [ ] Push code to repository
- [ ] Ensure `.gitignore` is working
- [ ] Add README with project info

## Apple Developer Setup

### 1. Apple Developer Account ✓
- [ ] Join Apple Developer Program ($99/year)
- [ ] Verify email and complete enrollment
- [ ] Wait for approval (usually 24-48 hours)
- [ ] Access developer.apple.com/account

### 2. App Store Connect ✓
- [ ] Log into appstoreconnect.apple.com
- [ ] Create new app listing
- [ ] Set Bundle ID: `com.yourcompany.zulutime_gps`
- [ ] Choose primary language
- [ ] Set app name (must be unique)

### 3. Certificates & Profiles ✓
- [ ] Create iOS Distribution Certificate
- [ ] Download certificate (.cer file)
- [ ] Create App Store Provisioning Profile
- [ ] Download provisioning profile (.mobileprovision)
- [ ] Keep certificate private key (.p12) secure

### 4. App Information ✓
- [ ] Write app description (170 chars short, 4000 chars full)
- [ ] List key features
- [ ] Add keywords for search
- [ ] Choose category (Utilities or Productivity)
- [ ] Set age rating
- [ ] Add privacy policy URL (required for location)

## Cloud Build Setup (Codemagic)

### 1. Account Setup ✓
- [ ] Sign up at codemagic.io
- [ ] Verify email address
- [ ] Connect to GitHub/GitLab
- [ ] Grant repository access

### 2. Configure Workflow ✓
- [ ] Import `codemagic.yaml` configuration
- [ ] Set environment variables
- [ ] Add Apple certificates
- [ ] Add provisioning profiles
- [ ] Configure App Store Connect API key

### 3. API Key Setup ✓
- [ ] Create App Store Connect API Key
- [ ] Download key (AuthKey_XXXXXXXX.p8)
- [ ] Note Key ID and Issuer ID
- [ ] Upload to Codemagic environment

### 4. Test Build ✓
- [ ] Trigger first build manually
- [ ] Watch build logs for errors
- [ ] Verify IPA is generated
- [ ] Download and inspect IPA

## TestFlight Testing

### 1. Upload Build ✓
- [ ] Build uploads to App Store Connect automatically
- [ ] Wait for processing (5-30 minutes)
- [ ] Check for processing errors
- [ ] Review export compliance

### 2. Internal Testing ✓
- [ ] Add internal testers (up to 100)
- [ ] Distribute build to testers
- [ ] Install via TestFlight app
- [ ] Test all features on physical device
- [ ] Check location permissions work
- [ ] Verify GPS accuracy

### 3. External Testing (Optional) ✓
- [ ] Submit for beta review (1-2 days)
- [ ] Add external testers (up to 10,000)
- [ ] Get feedback from testers
- [ ] Fix any reported issues
- [ ] Upload new builds as needed

## App Store Assets

### 1. Screenshots Required ✓
- [ ] 6.7" Display (iPhone 15 Pro Max): 1290 x 2796
- [ ] 6.5" Display (iPhone 14 Pro Max): 1284 x 2778
- [ ] 5.5" Display (iPhone 8 Plus): 1242 x 2208

**Tip**: Use iPhone simulators or actual devices
**Required**: 3-10 screenshots per device size

### 2. App Preview Video (Optional) ✓
- [ ] 15-30 second video
- [ ] Show key features
- [ ] No audio required
- [ ] Same resolutions as screenshots

### 3. App Icon ✓
- [ ] 1024 x 1024 PNG (no alpha channel)
- [ ] No rounded corners (Apple adds them)
- [ ] High quality, recognizable at small sizes

## Privacy & Compliance

### 1. Privacy Policy ✓
- [ ] Create privacy policy webpage
- [ ] Explain location data usage
- [ ] State data is not shared/sold
- [ ] Add policy URL to App Store Connect
- [ ] Add policy URL to app settings (optional)

### 2. Location Usage ✓
- [ ] Describe why app needs location
- [ ] Specify "When In Use" vs "Always"
- [ ] Explain in app description
- [ ] Ensure prompts are clear to users

### 3. Export Compliance ✓
- [ ] Answer encryption questions
- [ ] For this app: Select "No" (no encryption)
- [ ] Or select exception for standard Flutter encryption

## Final Submission

### 1. Pre-Submission Checklist ✓
- [ ] All TestFlight testing complete
- [ ] All bugs fixed
- [ ] Screenshots uploaded
- [ ] App description finalized
- [ ] Privacy policy active
- [ ] Support URL provided
- [ ] Marketing URL (optional)
- [ ] Age rating completed

### 2. Submit for Review ✓
- [ ] Click "Submit for Review"
- [ ] Select build version
- [ ] Answer review questions
- [ ] Add review notes (optional but helpful)
- [ ] Provide demo account if needed (N/A for this app)

### 3. During Review ✓
- [ ] Monitor review status daily
- [ ] Check App Store Connect notifications
- [ ] Respond quickly to any questions
- [ ] Be patient (typical: 24-72 hours)

### 4. After Approval ✓
- [ ] Decide on release timing
- [ ] Release manually or automatically
- [ ] Monitor crash reports
- [ ] Check user reviews
- [ ] Respond to user feedback
- [ ] Plan updates based on feedback

## Post-Launch

### 1. Monitoring ✓
- [ ] Set up App Store Connect notifications
- [ ] Check daily downloads and metrics
- [ ] Monitor crash reports
- [ ] Read user reviews
- [ ] Track battery/performance issues

### 2. Updates ✓
- [ ] Fix critical bugs immediately
- [ ] Plan feature updates
- [ ] Maintain regular update schedule
- [ ] Update screenshots when UI changes
- [ ] Keep privacy policy current

### 3. Marketing (Optional) ✓
- [ ] Share on social media
- [ ] Post to CAP/aviation communities
- [ ] Ask for reviews from satisfied users
- [ ] Create landing page
- [ ] Consider app promo codes

## Common Rejection Reasons

**Be ready to address:**
- Incomplete privacy policy
- Unclear location usage explanation
- Missing screenshots for required devices
- App crashes during review
- Inaccurate app description
- Missing demo account (not needed for this app)
- Copyright/trademark issues (avoid "Zulu" branding if trademarked)

## Timeline Estimate

- **Week 1**: Development (Windows/Android)
- **Week 2**: Apple Developer setup + Codemagic configuration
- **Week 3**: TestFlight testing + bug fixes
- **Week 4**: App Store submission + review (1-7 days)
- **Total**: 4-5 weeks from start to App Store launch

## Support Contacts

- **Apple Developer Support**: https://developer.apple.com/contact/
- **Codemagic Support**: support@codemagic.io
- **Flutter Discord**: https://discord.gg/flutter

## Notes

- Keep all certificates and keys secure and backed up
- Never share your Apple Developer credentials
- Test on physical devices before submission
- Have patience with App Review process
- Celebrate when approved! 🎉

---

*Last updated: February 2026*
