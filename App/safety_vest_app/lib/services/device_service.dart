import 'package:firebase_database/firebase_database.dart';


class DeviceService {


static Future<Map?> getDeviceData() async {


DatabaseReference ref =
FirebaseDatabase.instance
.ref("devices/vest001");


DatabaseEvent event =
await ref.once();


return event.snapshot.value as Map?;


}


}