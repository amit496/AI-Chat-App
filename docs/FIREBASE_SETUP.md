# Firebase Setup (Free Spark Plan)

## 1. Create project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project **voxera-app** (your own Firebase project)
3. Enable **Authentication** → Email, Google, Phone

## 2. Flutter configure

```bash
dart pub global activate flutterfire_cli
cd flutter_app
flutterfire configure
```

This updates `lib/firebase_options.dart` and downloads:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## 3. Google Sign-In

**Android:** Add SHA-1 in Firebase → Project settings → Your apps

```bash
cd flutter_app/android && ./gradlew signingReport
```

**iOS:** Add `GoogleService-Info.plist` and URL scheme from Firebase.

## 4. Phone OTP

Firebase Console → Authentication → Sign-in method → **Phone** → Enable.

Use test phone numbers in Firebase for development (no SMS cost).

## 5. Run app

```bash
flutter run
```

Until `flutterfire configure` completes, Google/OTP show: *Firebase not configured*.
