// ignore_for_file: annotate_overrides, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/device_service.dart';
import '../services/contact_service.dart';


class ProfileScreen extends StatefulWidget {


const ProfileScreen({super.key});


@override
State<ProfileScreen> createState()
=> _ProfileScreenState();


}



class _ProfileScreenState 
extends State<ProfileScreen>{

Map? deviceData;
Map? userData;
Map? emergencyContact;

@override
void initState() {
  super.initState();

  print(FirebaseAuth.instance.currentUser?.uid);

  loadUser();
  loadDevice();
  loadContact();
}



void loadUser() async {

  final data =
      await UserService.getUserData();

  if (!mounted) return;

  setState(() {
    userData = data;
  });

}





@override
Widget build(BuildContext context){
print(
 FirebaseAuth.instance.currentUser!.uid
);




return Scaffold(


appBar:

AppBar(

title:
const Text(
"Profile"
),

),



body:

SingleChildScrollView(

padding:
const EdgeInsets.all(20),



child:

Column(

children:[



CircleAvatar(

radius:50,

backgroundColor:
AppTheme.accentBlue,


child:

const Icon(

Icons.person,

size:60,

color:Colors.white,

),

),



const SizedBox(height:20),



Text(

userData?["name"] ?? "Unknown User",

style:
const TextStyle(
color:Colors.white,
fontSize:20,
fontWeight:FontWeight.bold,
),

),


const SizedBox(height:8),


Text(

userData?["role"] ?? "User",

style:

const TextStyle(
color:Colors.white70,
fontSize:15,
),

),

_profileCard(

icon:
Icons.person,

title:
"User Information",

subtitle:

"${userData?["email"] ?? "No Email"}",

),



_profileCard(

icon:
Icons.badge,

title:
"Role",

subtitle:

"${userData?["role"] ?? "User"}",

),

Container(

padding:
const EdgeInsets.all(18),

decoration:

BoxDecoration(

color:
AppTheme.surface,

borderRadius:
BorderRadius.circular(20),

),


child:

Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[


const Row(

children:[


Icon(
Icons.dark_mode,
color:
AppTheme.accentBlue,
),


SizedBox(width:15),


Text(

"Dark Mode",

style:

TextStyle(
color:Colors.white,
fontSize:16,
fontWeight:
FontWeight.bold,
),

),


],

),



Consumer<ThemeProvider>(

builder:(context,theme,child){


return Switch(

value:
theme.isDark,


onChanged:(value){


theme.toggleTheme(value);


},


);


}

)


],


),

),


const SizedBox(height:30),





_profileCard(

icon: Icons.lock,

title: "Change Password",

subtitle: "Update your account password",

),

_profileCard(

icon:
Icons.devices,

title:
"Device Information",

subtitle:

"${deviceData?["deviceName"] ?? "No Device Connected"}",

),



_profileCard(

icon:
Icons.cloud_done,

title:
"Firebase Status",

subtitle:
"Realtime Database Connected",

),



_profileCard(

icon:
Icons.info,

title:
"Application Version",

subtitle:
"Version 1.0.0",

),

_profileCard(

icon:
Icons.info_outline,

title:
"About Application",

subtitle:
"Smart Safety Vest IoT Monitoring System",

),

_profileCard(

icon:
Icons.phone,

title:
"Emergency Contacts",

subtitle:

emergencyContact?["phone"] ??
"No Contact Added",

),

const SizedBox(height:30),



SizedBox(

width:double.infinity,


child:

ElevatedButton.icon(

style:

ElevatedButton.styleFrom(

backgroundColor:
AppTheme.accentRose,

padding:
const EdgeInsets.all(16),

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15),

),

),



onPressed:() async{


await FirebaseAuth.instance.signOut();


Navigator.pushReplacementNamed(
context,
'/login'
);


},



icon:

const Icon(
Icons.logout,
color:Colors.white,
),



label:

const Text(

"Logout",

style:

TextStyle(

color:Colors.white,

fontSize:16,

),

),



),

),



],

),

),


);



}





Widget _profileCard({

required IconData icon,

required String title,

required String subtitle,


}){


return Container(

margin:
const EdgeInsets.only(bottom:15),


padding:
const EdgeInsets.all(18),


decoration:

BoxDecoration(

color:
AppTheme.surface,

borderRadius:
BorderRadius.circular(20),

),



child:

InkWell(

borderRadius:
BorderRadius.circular(20),

onTap: (){


if(title=="Change Password"){

_showChangePasswordDialog();

}


if(title=="About Application"){

_showAboutDialog();

}

if(title=="Device Information"){

_showDeviceDialog();

}

if(title=="Emergency Contacts"){

_showEmergencyDialog();

}

},


child:

Row(

children:[


Container(

padding:
const EdgeInsets.all(12),

decoration:

BoxDecoration(

color:
AppTheme.accentBlue
.withOpacity(.15),

borderRadius:
BorderRadius.circular(12),

),



child:

Icon(

icon,

color:
AppTheme.accentBlue,

),

),



const SizedBox(width:15),



Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

title,

style:

const TextStyle(

color:Colors.white,

fontWeight:
FontWeight.bold,

fontSize:16,

),

),



Text(

subtitle,

style:

const TextStyle(

color:Colors.white70,

),

),



],

)

],


),

),

);


}

void _showChangePasswordDialog(){


final passwordController =
TextEditingController();



showDialog(

context: context,

builder:(context){


return AlertDialog(


backgroundColor:
AppTheme.surface,


title:

const Text(

"Change Password",

style:

TextStyle(
color:Colors.white
),

),



content:

TextField(

controller:
passwordController,


obscureText:true,


style:

const TextStyle(
color:Colors.white
),



decoration:

const InputDecoration(

labelText:
"New Password",

labelStyle:

TextStyle(
color:Colors.white70
),

),


),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},

child:

const Text(
"Cancel"
),

),



ElevatedButton(


onPressed: () async {

  if (passwordController.text.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a password"),
      ),
    );

    return;
  }

  if (passwordController.text.length < 6) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password must be at least 6 characters"),
      ),
    );

    return;
  }

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No user is signed in"),
      ),
    );

    return;
  }

  try {

    await user.updatePassword(
      passwordController.text,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password Updated Successfully"),
      ),
    );

  } on FirebaseAuthException catch (e) {

    String message;

    switch (e.code) {

      case "requires-recent-login":
        message =
            "Please log in again before changing your password.";
        break;

      case "weak-password":
        message =
            "Please choose a stronger password.";
        break;

      default:
        message = e.message ?? "Password update failed.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );

  }

},



child:

const Text(
"Update"
),

)


],



);


});


}
void _showAboutDialog(){


showDialog(

context: context,

builder:(context){


return AlertDialog(


backgroundColor:
AppTheme.surface,


title:

const Text(

"Smart Safety Vest",

style:

TextStyle(

color:Colors.white,

fontWeight:
FontWeight.bold,

),

),



content:

const Column(

mainAxisSize:
MainAxisSize.min,


crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

"Version: 1.0.0",

style:

TextStyle(
color:Colors.white70,
),

),



SizedBox(height:10),



Text(

"Developed By:\nPavan Samarakkodi",

style:

TextStyle(
color:Colors.white70,
),

),



SizedBox(height:10),



Text(

"Technology:\n\n"
"• Flutter\n"
"• Firebase\n"
"• ESP8266 IoT\n"
"• Realtime Database\n"
"• GPS Tracking\n\n"
"Features:\n"
"✓ Worker Monitoring\n"
"✓ Gas Detection\n"
"✓ Fall Detection\n"
"✓ Heart Rate Monitoring",

style:

TextStyle(
color:Colors.white70,
),

),


],


),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},


child:

const Text(
"Close"
),

)


],


);


});


}
void loadDevice() async {

  final data =
      await DeviceService.getDeviceData();

  if (!mounted) return;

  setState(() {
    deviceData = data;
  });

}

void _showDeviceDialog(){


showDialog(

context: context,

builder:(context){


return AlertDialog(

backgroundColor:
AppTheme.surface,


title:

const Text(

"Device Information",

style:

TextStyle(
color:Colors.white,
),

),


content:

Text(

"Vest ID: ${deviceData?["vestId"] ?? "N/A"}\n\n"

"Status: ${deviceData?["status"] ?? "Offline"}\n\n"

"Battery: ${deviceData?["battery"] ?? 0}%\n\n"

"Firmware: ${deviceData?["firmware"] ?? "Unknown"}\n\n"

"Last Sync:\n"
"${deviceData?["lastSync"] ?? "Unknown"}",


style:

const TextStyle(

color:Colors.white70,

fontSize:15,

),


),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},


child:

const Text("Close"),

)

],


);


});


}


void loadContact() async {

  final data =
      await ContactService.getContact();

  if (!mounted) return;

  setState(() {
    emergencyContact = data;
  });

}


void _showEmergencyDialog(){


final nameController =
TextEditingController();


final phoneController =
TextEditingController();


final emailController =
TextEditingController();



showDialog(

context: context,

builder:(context){


return AlertDialog(

backgroundColor:
AppTheme.surface,


title:

const Text(

"Emergency Contact",

style:

TextStyle(
color:Colors.white
),

),



content:

Column(

mainAxisSize:
MainAxisSize.min,

children:[


TextField(

controller:nameController,

decoration:
const InputDecoration(
labelText:"Name"
),

),



TextField(

controller:phoneController,

keyboardType:
TextInputType.phone,

decoration:
const InputDecoration(
labelText:"Phone"
),

),



TextField(

controller:emailController,

decoration:
const InputDecoration(
labelText:"Email"
),

),


],

),



actions:[


ElevatedButton(

onPressed: () async {

  // Validate Name
  if (nameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a contact name"),
      ),
    );
    return;
  }

  // Validate Phone
  if (phoneController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a phone number"),
      ),
    );
    return;
  }

  if (phoneController.text.trim().length < 10) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Phone number must be at least 10 digits"),
      ),
    );
    return;
  }

  // Validate Email
  if (emailController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter an email address"),
      ),
    );
    return;
  }

  final emailRegex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w+$',
  );

  if (!emailRegex.hasMatch(emailController.text.trim())) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid email address"),
      ),
    );
    return;
  }

  await ContactService.saveContact(
    nameController.text.trim(),
    phoneController.text.trim(),
    emailController.text.trim(),
  );

  Navigator.pop(context);

  loadContact();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Emergency contact saved successfully"),
    ),
  );
},


child:

const Text(
"Save"
),

)


],


);


});


}
}