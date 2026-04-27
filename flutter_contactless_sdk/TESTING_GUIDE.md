# Local Testing Guide (Android)

Follow these steps to test the Contactless SDK on your physical Android device.

## 1. Prerequisites
- **Physical Android Phone**: With NFC hardware.
- **Enable NFC**: Go to Settings -> Connected Devices -> Connection Preferences -> NFC (Enable).
- **Developer Options**: Enable "USB Debugging" on your phone.
- **Connect**: Connect your phone to your PC via USB and run `adb devices` to verify connection.

## 2. Setup the Example App
Since we manually created the project structure, you may need to let Flutter generate some environment-specific files.

Navigate to the example directory:
```bash
cd example
```

Run Flutter clean and get dependencies:
```bash
flutter clean
flutter pub get
```

## 3. Run the App
With your phone connected, run the following command:
```bash
flutter run
```

## 4. Test Native Features
Once the app is running:
1. The screen will show if **NFC Hardware** is detected.
2. Tap **"Start Payment Session"**.
3. The SDK will trigger the `startPayment` logic (currently returning a mock success with transaction details).

---

## Troubleshooting
- **Gradle Errors**: If you encounter Gradle errors, ensure your `local.properties` file in `example/android/` contains the correct `flutter.sdk` path.
- **NFC Not Found**: Ensure the phone actually has NFC hardware and it is turned ON.
- **Permission Denied**: The Android Manifest already includes `<uses-permission android:name="android.permission.NFC" />`.
