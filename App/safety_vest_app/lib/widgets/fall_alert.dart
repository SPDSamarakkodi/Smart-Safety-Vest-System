import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class FallAlert extends StatelessWidget {


final bool fall;


const FallAlert({

super.key,

required this.fall,

});



@override
Widget build(BuildContext context){


return Container(

padding:
const EdgeInsets.all(22),


decoration:
BoxDecoration(

color:
fall
?
AppTheme.accentRose
:
AppTheme.accentEmerald,


borderRadius:
BorderRadius.circular(24),

),


child:
Row(

children:[


Icon(

fall
?
Icons.warning
:
Icons.verified_user,


color:
Colors.white,

size:35,

),


const SizedBox(width:15),



Expanded(

child:
Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

fall
?
"FALL DETECTED!"
:
"ALL CLEAR",


style:
const TextStyle(

color:
Colors.white,

fontSize:20,

fontWeight:
FontWeight.bold,

),

),


const SizedBox(height:5),


Text(

fall
?
"Immediate attention required"
:
"Worker status normal",


style:
const TextStyle(

color:
Colors.white70,

),

)


],

),

)

],

),

);

}

}