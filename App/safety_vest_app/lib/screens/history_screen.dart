// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sensor_chart.dart';
import '../theme/app_theme.dart';
import '../services/pdf_service.dart';
import '../models/report_model.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class HistoryScreen extends StatefulWidget {

const HistoryScreen({super.key});


@override
State<HistoryScreen> createState()
=> _HistoryScreenState();

}



class _HistoryScreenState
extends State<HistoryScreen>{
Future<void> deleteHistory() async {


try {


await db.remove();


ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:
Text(
"History deleted successfully"
),

),

);


}
catch(e){


ScaffoldMessenger.of(context).showSnackBar(

SnackBar(

content:
Text(
"Delete failed: $e"
),

),

);


}


}
final ScreenshotController temperatureController =
ScreenshotController();


final ScreenshotController gasController =
ScreenshotController();

final DatabaseReference db =
FirebaseDatabase.instance.ref("history");


final DatabaseReference gpsDB =
FirebaseDatabase.instance.ref("gps");


List<FlSpot> temperaturePoints = [];
List<FlSpot> humidityPoints = [];
List<FlSpot> gasPoints = [];
List<FlSpot> heartRatePoints = [];

double latestLatitude = 0;
double latestLongitude = 0;

double calculateAverage(
List<FlSpot> data
){

if(data.isEmpty)
return 0;


double total=0;


for(var item in data){

total += item.y;

}


return total/data.length;

}





double getMax(
List<FlSpot> data
){

double max=0;


for(var item in data){

if(item.y>max){

max=item.y;

}

}


return max;

}





double getMin(
List<FlSpot> data
){

if(data.isEmpty)
return 0;


double min=data.first.y;


for(var item in data){

if(item.y<min){

min=item.y;

}

}


return min;

}

@override
void initState(){

super.initState();

loadHistory();

}



void loadHistory() {

  db.orderByChild("timestamp")
      .limitToLast(20)
      .onValue
      .listen((event) {

    final data =
        event.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) {
  print("History is empty!");
  return;
}

print("History loaded!");
print(data);

    List<Map> values = [];

    data.forEach((key, value) {

  print("Record:");

  print(value);

  values.add(Map.from(value));

});

    values.sort((a, b) =>
        (a["timestamp"] ?? 0)
            .compareTo(b["timestamp"] ?? 0));

List<FlSpot> tempPoints = [];
List<FlSpot> humPoints = [];
List<FlSpot> gasPoints = [];
List<FlSpot> heartPoints = [];

// Get latest GPS location

gpsDB.onValue.listen((gpsEvent){

final gpsData =
gpsEvent.snapshot.value as Map<dynamic,dynamic>?;


if(gpsData != null){


setState((){


latestLatitude =
double.tryParse(
gpsData["latitude"].toString()
) ?? 0;


latestLongitude =
double.tryParse(
gpsData["longitude"].toString()
) ?? 0;



});


print("GPS Latitude: $latestLatitude");
print("GPS Longitude: $latestLongitude");


}


});

for(int i=0;i<values.length;i++){


double temperature =
double.tryParse(
values[i]["temperature"].toString()
) ?? 0;


double humidity =
double.tryParse(
values[i]["humidity"].toString()
) ?? 0;


double gas =
double.tryParse(
values[i]["gas"].toString()
) ?? 0;


double heart =
double.tryParse(
values[i]["heartRate"].toString()
) ?? 0;



tempPoints.add(
FlSpot(
i.toDouble(),
temperature
)
);


humPoints.add(
FlSpot(
i.toDouble(),
humidity
)
);


gasPoints.add(
FlSpot(
i.toDouble(),
gas
)
);


heartPoints.add(
FlSpot(
i.toDouble(),
heart
)
);


}



print("Total Records: ${values.length}");
    setState(() {

      temperaturePoints = tempPoints;

      humidityPoints = humPoints;

      this.gasPoints = gasPoints;

      heartRatePoints = heartPoints;

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

SingleChildScrollView(

child:

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

ElevatedButton.icon(

icon:
const Icon(Icons.picture_as_pdf),


label:
const Text(
"Generate PDF Report"
),


onPressed: () async {

print("PDF Latitude : $latestLatitude");
print("PDF Longitude : $latestLongitude");

final temperatureImage =
await temperatureController.capture();


final gasImage =
await gasController.capture();



await PdfService.generateReport(

ReportModel(

workerId:
"WORKER_001",


temperatureAvg:
calculateAverage(temperaturePoints),


temperatureMax:
getMax(temperaturePoints),


temperatureMin:
getMin(temperaturePoints),


humidity:
humidityPoints.isNotEmpty
? humidityPoints.last.y
: 0,


gas:
gasPoints.isNotEmpty
? gasPoints.last.y
: 0,


heartRate:
heartRatePoints.isNotEmpty
? heartRatePoints.last.y
: 0,


latitude:
latestLatitude,


longitude:
latestLongitude,

),


temperatureImage,


gasImage,


);


},


),

const SizedBox(height:10),


ElevatedButton.icon(

icon:
const Icon(
Icons.delete
),


label:
const Text(
"Delete History"
),



style:
ElevatedButton.styleFrom(



),



onPressed: (){


showDialog(

context:context,

builder:(context){


return AlertDialog(

title:
const Text(
"Delete History?"
),


content:
const Text(
"Are you sure you want to delete all sensor history?"
),



actions:[


TextButton(

child:
const Text(
"Cancel"
),


onPressed:(){

Navigator.pop(context);

},

),



TextButton(

child:
const Text(
"Delete"
),


onPressed:(){


Navigator.pop(context);


deleteHistory();


},


),


],


);


}

);


},


),

Screenshot(

controller: temperatureController,

child:

SensorChart(

title:"Temperature",

data:temperaturePoints,

color:Colors.blue,

),

),


SensorChart(

title:"Humidity",

data:humidityPoints,

color:Colors.green,

),


Screenshot(

controller: gasController,

child:

SensorChart(

title:"Gas Level",

data:gasPoints,

color:Colors.red,

),

),


SensorChart(

title:"Heart Rate",

data:heartRatePoints,

color:Colors.pink,

),


],

),

),

),

);


}


}