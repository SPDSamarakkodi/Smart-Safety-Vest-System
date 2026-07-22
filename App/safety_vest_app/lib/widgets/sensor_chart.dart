import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class SensorChart extends StatelessWidget{


final String title;

final List<FlSpot> data;

final Color color;


const SensorChart({

super.key,

required this.title,

required this.data,

required this.color,

});



@override
Widget build(BuildContext context){


return Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

title,

style:
const TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



SizedBox(

height:250,


child:

LineChart(

LineChartData(


gridData:
const FlGridData(
show:true
),


borderData:
FlBorderData(
show:true
),


lineBarsData:[


LineChartBarData(

spots:data,

isCurved:true,

color:color,

barWidth:4,

dotData:
const FlDotData(
show:true
),


)


],



),

),


),



const SizedBox(height:30)



],


);


}


}