// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';



class ProfileScreen extends StatelessWidget {


const ProfileScreen({super.key});



@override
Widget build(BuildContext context){


final user =
FirebaseAuth.instance.currentUser;



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

user?.email ?? "Unknown User",


style:

const TextStyle(

color:Colors.white,

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:30),




_profileCard(

icon:
Icons.security,

title:
"Smart Safety Vest",

subtitle:
"Worker Monitoring System",

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


);


}



}