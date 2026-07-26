# Smart Safety Vest System

A Flutter mobile dashboard for real-time monitoring of wearable safety vest telemetry.

## Overview

This app connects to Firebase Realtime Database and displays live data from a smart safety vest, including:
- Temperature
- Humidity
- Gas level
- Heart rate
- Fall detection status
- Live GPS tracking on an interactive map

The interface uses a dark modern theme with real-time status indicators and an animated safety alert banner.

## Features

- Real-time telemetry using Firebase Realtime Database
- Live GPS tracking with `flutter_map` and OpenStreetMap tiles
- Fall detection alert state with animated visuals
- Sensor dashboards with progress indicators
- Device connection status and map centering button

## Setup

1. Clone the repository:

```bash
git clone <your-repo-url>
cd App/safety_vest_app
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

- Ensure the project contains the generated `firebase_options.dart` file under `lib/`
- Ensure `android/app/google-services.json` is present for Android
- Ensure iOS Firebase config files are set up if building for iOS

4. Run the app:

```bash
flutter run
```

## Project Structure

- `lib/main.dart` - Main app entry and dashboard UI
- `lib/firebase_options.dart` - Generated Firebase configuration
- `android/` - Android app configuration and Gradle files
- `ios/` - iOS app configuration
- `pubspec.yaml` - Flutter dependencies and assets

## Dependencies

Key packages used by this app:

- `firebase_core`
- `firebase_database`
- `flutter_map`
- `latlong2`
- `flutter_map_animations`

## Firebase Database Schema

The app expects a JSON structure similar to:

```json
{
  "sensor": {
    "temperature": 24.5,
    "humidity": 56.7,
    "gas": 120,
    "heartRate": 78,
    "fall": false
  },
  "gps": {
    "latitude": 6.9271,
    "longitude": 79.8612
  }
}
```

## Notes

- The map marker and live location view update when GPS coordinates are available.
- The app uses `AnimatedMapController` to smoothly animate the map to the latest location.
- If the Firebase data is not available, the app shows a connecting state and waits for telemetry.

## License

This repository is available for educational use. Update the license section as needed for your project.
