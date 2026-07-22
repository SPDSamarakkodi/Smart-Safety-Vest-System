// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class StatusCard extends StatelessWidget {


final bool online;
final DateTime? lastUpdated;

final String workerStatus;
final Color workerStatusColor;


const StatusCard({
  super.key,
  required this.online,
  required this.lastUpdated,
  required this.workerStatus,
  required this.workerStatusColor,
});



@override
Widget build(BuildContext context){


return Container(

padding:
const EdgeInsets.all(20),


decoration:
BoxDecoration(

gradient:
LinearGradient(

colors:[

AppTheme.accentBlue.withOpacity(0.3),

AppTheme.accentCyan.withOpacity(0.2),

],

),


borderRadius:
BorderRadius.circular(24),

),



child:
Row(

children:[


Container(

width:14,

height:14,

decoration:
BoxDecoration(

shape:
BoxShape.circle,


color:
online
?
AppTheme.accentEmerald
:
AppTheme.accentRose,

),

),



const SizedBox(width:15),



Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

online
?
"Device Online"
:
"Connecting...",


style:
const TextStyle(

color:
Colors.white,

fontSize:18,

fontWeight:
FontWeight.bold,

),

),


const SizedBox(height:5),


Text(
  lastUpdated == null
      ? "Waiting for sensor data..."
      : "Last Updated : "
          "${lastUpdated!.hour.toString().padLeft(2, '0')}:"
          "${lastUpdated!.minute.toString().padLeft(2, '0')}:"
          "${lastUpdated!.second.toString().padLeft(2, '0')}",
  style: const TextStyle(
    color: Colors.white70,
  ),
)


],

)

],

),

);

}

}