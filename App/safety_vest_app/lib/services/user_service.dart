import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserService {


static Future<Map?> getUserData() async {


final user =
FirebaseAuth.instance.currentUser;


if(user == null){

return null;

}



DatabaseReference ref =
FirebaseDatabase.instance
.ref("users/${user.uid}");



DatabaseEvent event =
await ref.once();



return event.snapshot.value as Map?;

}


}