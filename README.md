# Smart Safety Vest System

A complete smart wearable safety vest project with:
- Flutter mobile dashboard app for real-time telemetry
- Firebase Realtime Database integration
- ESP8266-based wearable firmware for temperature, humidity, gas, heart rate, fall detection, and GPS

## Project Overview

The Smart Safety Vest System is an IoT safety solution that monitors a wearable vest and reports live sensor data to a mobile dashboard. The system combines:
- An Android/iOS/desktop Flutter app in `App/safety_vest_app`
- Firebase Realtime Database for telemetry exchange
- ESP8266 firmware in `CW-Project/Full-Code/final-code01` for sensor reading and safety alerts

## Features

- Real-time sensor data display in Flutter
- Live map tracking using GPS coordinates
- Fall detection and alert status
- Gas sensor monitoring
- Heart rate monitoring
- Animated safety dashboard UI
- Buzzer and LED alert output from the vest firmware

## Folder Structure

- `App/safety_vest_app/` - Flutter dashboard app
- `App/safety_vest_app/lib/` - Flutter source code
- `App/safety_vest_app/lib/main.dart` - App entry point
- `App/safety_vest_app/lib/firebase_options.dart` - Generated Firebase config
- `CW-Project/Full-Code/final-code01/` - Final Arduino firmware for the wearable device
- `CW-Project/Testing/` - Sensor test sketches and prototypes
- `Web Dashboard/` - Optional web dashboard files

## Mobile App Setup

1. Clone the repository:

```bash
git clone <your-repo-url>
cd "Smart-Safety-Vest-System/App/safety_vest_app"
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Configure Firebase:
- The project already includes `lib/firebase_options.dart`.
- Ensure Android `google-services.json` is present in `android/app/`.
- If building for iOS, ensure Firebase is configured in Xcode.

4. Run the app:

```bash
flutter run
```

## Firmware Setup

1. Open `CW-Project/Full-Code/final-code01/final-code01.ino` in Arduino IDE.
2. Add your Wi-Fi credentials in `CW-Project/Full-Code/final-code01/secrets.h`.
3. Connect the ESP8266 and sensor modules as defined in the code:
   - `DHT11` on `D4`
   - `MQ7` gas sensor on `A0`
   - `MAX30102` heart rate sensor via I2C
   - `MPU6050` for motion/fall detection via I2C
   - GPS module on `D6`/`D5`
   - `BUZZER` on `D7`
   - `LED` on `D0`
4. Upload the sketch to the ESP8266.

## Firebase Schema

The mobile app expects this Realtime Database structure:

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

## Key Dependencies

### Flutter app
- `firebase_core`
- `firebase_database`
- `flutter_map`
- `latlong2`
- `flutter_map_animations`

### Device firmware
- `ESP8266WiFi`
- `Firebase`
- `DHT`
- `MPU6050`
- `TinyGPS++`
- `MAX30105`

## Notes

- The dashboard only displays data when the Firebase Realtime Database is populated by the ESP8266 firmware.
- GPS coordinates are used to animate the map and center on the vest location.
- The wearable firmware triggers buzzer and LED alerts when gas, fall detection, or high heart rate thresholds are exceeded.

## License

This repository is intended for educational use. Update the license section as needed for your project.
