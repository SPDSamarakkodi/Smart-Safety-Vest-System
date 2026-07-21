import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_theme.dart';


class HistoryScreen extends StatefulWidget {

const HistoryScreen({super.key});


@override
State<HistoryScreen> createState()
=> _HistoryScreenState();

}



class _HistoryScreenState
extends State<HistoryScreen>{


final DatabaseReference db =
FirebaseDatabase.instance.ref("history");


List<FlSpot> temperaturePoints=[];



@override
void initState(){

super.initState();

loadHistory();

}



void loadHistory(){


db.limitToLast(20)
.onValue.listen((event){


final data =
event.snapshot.value
as Map<dynamic,dynamic>?;



if(data==null)return;



List<FlSpot> points=[];


int index=0;


data.forEach((key,value){


points.add(

FlSpot(

index.toDouble(),

double.tryParse(
value["temperature"]
.toString()
) ?? 0,

)

);


index++;


});



setState((){


temperaturePoints=points;


});



});


}





@override
Widget build(BuildContext context){


return Scaffold(


appBar:
AppBar(

title:
const Text(
"Sensor History"
),

),



body:

Padding(

padding:
const EdgeInsets.all(20),


child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



const Text(

"Temperature History",

style:
TextStyle(

fontSize:22,

color:Colors.white,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:20),



Container(

height:300,

padding:
const EdgeInsets.all(20),


decoration:
BoxDecoration(

color:
AppTheme.surface,

borderRadius:
BorderRadius.circular(25),

),



child:

LineChart(

LineChartData(

lineBarsData:[


LineChartBarData(

spots:
temperaturePoints,


isCurved:true,


barWidth:4,


dotData:
const FlDotData(show:true),


),


],


),


),


),



],

),


),



);


}


}