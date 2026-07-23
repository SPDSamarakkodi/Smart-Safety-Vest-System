import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_card.dart';
import '../widgets/fall_alert.dart';



class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState()
      => _DashboardScreenState();

}



class _DashboardScreenState
    extends State<DashboardScreen> {

StreamSubscription<DatabaseEvent>? _dashboardSubscription;

final DatabaseReference db =
FirebaseDatabase.instance.ref();



double temperature = 0;
double humidity = 0;

int gas = 0;
int heartRate = 0;

bool fall = false;

bool online = false;

DateTime? lastUpdated;

String workerStatus = "SAFE";
Color workerStatusColor = Colors.green;

@override
void initState(){

super.initState();

readFirebase();

}



void readFirebase(){


_dashboardSubscription =
    db.onValue.listen((event){


final data =
event.snapshot.value
as Map<dynamic,dynamic>?;


if(data == null) return;



final sensor =
data["sensor"];


if(sensor == null) return;



if (!mounted) return;

setState((){

temperature =


temperature =
double.tryParse(
sensor["temperature"]
.toString()
) ?? 0;



humidity =
double.tryParse(
sensor["humidity"]
.toString()
) ?? 0;



gas =
int.tryParse(
sensor["gas"]
.toString()
) ?? 0;



heartRate =
int.tryParse(
sensor["heartRate"]
.toString()
) ?? 0;



fall =
sensor["fall"] ?? false;



online = true;
lastUpdated = DateTime.now();
// Determine worker health status

if (fall) {
  workerStatus = "DANGER";
  workerStatusColor = Colors.red;
}
else if (gas >= 300) {
  workerStatus = "DANGER";
  workerStatusColor = Colors.red;
}
else if (temperature >= 38) {
  workerStatus = "WARNING";
  workerStatusColor = Colors.orange;
}
else if (heartRate >= 120 || heartRate <= 50) {
  workerStatus = "WARNING";
  workerStatusColor = Colors.orange;
}
else {
  workerStatus = "SAFE";
  workerStatusColor = Colors.green;
}

});


});


}



@override
Widget build(BuildContext context){


return Scaffold(


backgroundColor:
AppTheme.darkBg,


body:
SafeArea(


child:
SingleChildScrollView(


padding:
const EdgeInsets.all(20),



child:
Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



Container(
  width: double.infinity,
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppTheme.accentBlue,
        AppTheme.accentCyan,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Row(
        children: const [

          Icon(
            Icons.shield,
            color: Colors.white,
            size: 34,
          ),

          SizedBox(width: 12),

          Text(
            "Smart Safety Vest",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      SizedBox(height: 10),

      Text(
        "Real-Time Worker Monitoring System",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),
const SizedBox(height: 10),

Row(
  children: [

    Icon(
      Icons.health_and_safety,
      color: workerStatusColor,
      size: 20,
    ),

    const SizedBox(width: 8),

    Text(
      workerStatus,
      style: TextStyle(
        color: workerStatusColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),

  ],
),
    ],
  ),
),

const SizedBox(height:20),

StatusCard(
  online: online,
  lastUpdated: lastUpdated,
  workerStatus: workerStatus,
  workerStatusColor: workerStatusColor,
),

const SizedBox(height:25),



const Text(

"Vitals & Environment",

style:
TextStyle(

color:
Colors.white,

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



GridView.count(

shrinkWrap:true,

physics:
const NeverScrollableScrollPhysics(),


crossAxisCount:2,


crossAxisSpacing:15,

mainAxisSpacing:15,


children:[



SensorCard(

title:"Temperature",

value:
temperature.toStringAsFixed(1),

unit:"°C",

icon:
Icons.thermostat,

color:
AppTheme.accentRose,

),



SensorCard(

title:"Humidity",

value:
humidity.toStringAsFixed(1),

unit:"%",

icon:
Icons.water_drop,

color:
AppTheme.accentBlue,

),



SensorCard(

title:"Gas Level",

value:
gas.toString(),

unit:"ppm",

icon:
Icons.cloud,

color:
AppTheme.accentAmber,

),



SensorCard(

title:"Heart Rate",

value:
heartRate.toString(),

unit:"BPM",

icon:
Icons.favorite,

color:
AppTheme.accentRose,

),



],


),



const SizedBox(height:30),



const Text(

"Safety Status",

style:
TextStyle(

color:
Colors.white,

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



FallAlert(

fall:
fall,

),



],


),


),


),


);


}

@override
void dispose() {

  _dashboardSubscription?.cancel();

  super.dispose();

}

}