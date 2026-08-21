# Scanova QR

A production-oriented, offline-first Flutter QR scanner for Android.

## Features

- Fast real-time QR/barcode scanning with CameraX/ML Kit through `mobile_scanner`.
- Scan QR from camera or from a gallery image.
- Flashlight toggle and animated scan frame.
- Duplicate-scan throttling.
- Result classification for URL, text, phone, email, SMS, Wi-Fi, contact and location payloads.
- Local history stored only on-device.
- Copy, share and user-confirmed open actions.
- Light / dark / system theme.
- English / Arabic UI.
- Haptic feedback preference.
- No backend, analytics, login, or automatic link opening.

## Build

Requires Flutter 3.47.0 or newer, Android SDK, and Java 17+.

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

Release APK output:
`build/app/outputs/flutter-apk/app-release.apk`

The current execution environment used to assemble this project does not have Flutter or the Android SDK installed, so APK compilation could not be performed here.
