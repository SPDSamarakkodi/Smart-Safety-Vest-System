// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import '../theme/app_theme.dart';



class SplashScreen extends StatefulWidget {

const SplashScreen({super.key});


@override
State<SplashScreen> createState()
=> _SplashScreenState();

}



class _SplashScreenState
extends State<SplashScreen>
with SingleTickerProviderStateMixin {



late AnimationController controller;

late Animation<double> scale;

late Animation<double> fade;



@override
void initState(){

super.initState();



controller =
AnimationController(

vsync:this,

duration:
const Duration(seconds:2),

);



scale =
CurvedAnimation(

parent:controller,

curve:
Curves.elasticOut,

);



fade =
CurvedAnimation(

parent:controller,

curve:
Curves.easeIn,

);



controller.forward();



Future.delayed(

const Duration(seconds:4),

(){

if(!mounted)return;



final user =
FirebaseAuth.instance.currentUser;



if(user!=null){

Navigator.pushReplacementNamed(
context,
'/home'
);

}

else{


Navigator.pushReplacementNamed(
context,
'/login'
);


}


},

);



}





@override
Widget build(BuildContext context){


return Scaffold(


body:

Container(


decoration:

const BoxDecoration(

gradient:

LinearGradient(

begin:
Alignment.topLeft,

end:
Alignment.bottomRight,


colors:[

Color(0xFF0B0F19),

Color(0xFF1E2642),

],


),

),



child:

Center(


child:

FadeTransition(

opacity:
fade,


child:

ScaleTransition(

scale:
scale,


child:

Column(

mainAxisSize:
MainAxisSize.min,


children:[



Container(

padding:
const EdgeInsets.all(25),


decoration:

BoxDecoration(

shape:
BoxShape.circle,


color:
Colors.white.withOpacity(.1),


),



child:

const Icon(

Icons.shield_outlined,

size:80,

color:
Colors.white,

),


),



const SizedBox(height:25),



const Text(

"Smart Safety Vest",

style:

TextStyle(

color:
Colors.white,

fontSize:30,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:10),



const Text(

"Worker Monitoring System",

style:

TextStyle(

color:
Colors.white70,

fontSize:16,

),

),



const SizedBox(height:40),



const CircularProgressIndicator(

color:
Colors.cyan,

),



const SizedBox(height:15),



const Text(

"Loading...",

style:

TextStyle(

color:
Colors.white70,

),

),



],


),


),

),

),


),


);


}



@override
void dispose(){

controller.dispose();

super.dispose();

}


}