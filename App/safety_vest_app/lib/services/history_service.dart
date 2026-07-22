import 'package:firebase_database/firebase_database.dart';

class HistoryService {
  static final DatabaseReference db =
      FirebaseDatabase.instance.ref();

  static void startListening() {
    db.child("sensor").onValue.listen((event) async {
      final sensor =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (sensor == null) return;

      await db.child("history").push().set({
        "temperature":
            double.tryParse(sensor["temperature"].toString()) ?? 0,

        "humidity":
            double.tryParse(sensor["humidity"].toString()) ?? 0,

        "gas":
            int.tryParse(sensor["gas"].toString()) ?? 0,

        "heartRate":
            int.tryParse(sensor["heartRate"].toString()) ?? 0,

        "fall":
            sensor["fall"] ?? false,

        "latitude":
            double.tryParse(
                    sensor["latitude"]?.toString() ?? "0") ??
                0,

        "longitude":
            double.tryParse(
                    sensor["longitude"]?.toString() ?? "0") ??
                0,

        "timestamp":
            ServerValue.timestamp,
      });
    });
  }
}