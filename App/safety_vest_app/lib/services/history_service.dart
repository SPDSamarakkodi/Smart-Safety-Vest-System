import 'package:firebase_database/firebase_database.dart';


class HistoryService {

  static final DatabaseReference db =
      FirebaseDatabase.instance.ref();


  static Future<void> save({

    required double temperature,
    required double humidity,
    required int gas,
    required int heartRate,
    required bool fall,
    required double latitude,
    required double longitude,

  }) async {


    await db
        .child("history")
        .push()
        .set({

      "temperature": temperature,

      "humidity": humidity,

      "gas": gas,

      "heartRate": heartRate,

      "fall": fall,

      "latitude": latitude,

      "longitude": longitude,

      "timestamp":
      DateTime.now()
          .millisecondsSinceEpoch,

    });

  }

}