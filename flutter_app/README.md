# GJandAsher ShipTracker - Flutter Mobile App

This directory contains the complete Flutter & Dart mobile application for **GJandAsher ShipTracker**, ready to be opened, tested, and run directly in **Android Studio**.

## Features Included
- **Parcels Dashboard**: Marketplace filters (Shopee, Lazada, TikTok), Courier filters (SPX, J&T, etc.), and Date filters (Today, Last Week, Last Month, Custom Date Range).
- **Manual Dispatch Form**: Waybill generator, courier matching, and customer logging.
- **Returns & Refunds Logger**: Return condition assessment, refund resolution statuses, and photo verification.
- **Visual Analytics**: 1–12 Month predictive forecasting slider and GMV KPI metrics.
- **Profile & DPA Compliance**: User profile, Firestore role toggle, and RA 10173 data privacy consent.

## How to Test in Android Studio

1. **Prerequisites**:
   - Install **Android Studio** (Koala, Ladybug, Iguana, or later).
   - In Android Studio, go to **Settings/Preferences → Plugins** and install the **Flutter** and **Dart** plugins.
   - Install the Flutter SDK (via [flutter.dev](https://docs.flutter.dev/get-started/install)).

2. **Open in Android Studio**:
   - Open Android Studio and choose **Open...**
   - Select the `flutter_app` folder.
   - Android Studio will detect `pubspec.yaml` and offer to run `flutter pub get`.

3. **Run on Android Emulator or Device**:
   - Start an Android Emulator from **Device Manager** (or plug in a physical Android phone with USB debugging enabled).
   - Click the green **Run (▶)** button or run in terminal:
     ```bash
     flutter run
     ```
