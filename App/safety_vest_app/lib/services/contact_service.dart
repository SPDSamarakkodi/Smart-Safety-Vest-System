import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class ContactService {


static Future<Map?> getContact() async {


final user =
FirebaseAuth.instance.currentUser;


if(user == null){
return null;
}


DatabaseReference ref =
FirebaseDatabase.instance
.ref(
"users/${user.uid}/emergencyContact"
);



DatabaseEvent event =
await ref.once();



return event.snapshot.value as Map?;


}



static Future<void> saveContact(
String name,
String phone,
String email
) async {


final user =
FirebaseAuth.instance.currentUser;


if(user == null) return;



await FirebaseDatabase.instance
.ref(
"users/${user.uid}/emergencyContact"
)
.set({

"name":name,

"phone":phone,

"email":email,


});


}


}