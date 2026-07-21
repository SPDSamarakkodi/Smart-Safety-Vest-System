import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';



class AlertsScreen extends StatefulWidget {

  const AlertsScreen({super.key});


  @override
  State<AlertsScreen> createState()
  => _AlertsScreenState();

}



class _AlertsScreenState
extends State<AlertsScreen>{


final DatabaseReference db =
FirebaseDatabase.instance.ref();



double temperature = 0;

int gas = 0;

bool fall = false;



List<Map<String,dynamic>> alerts=[];



@override
void initState(){

super.initState();

listenAlerts();

}



void listenAlerts(){


db.onValue.listen((event){


final data =
event.snapshot.value
as Map<dynamic,dynamic>?;


if(data==null)return;



final sensor =
data["sensor"];


if(sensor==null)return;



temperature =
double.tryParse(
sensor["temperature"].toString()
) ?? 0;


gas =
int.tryParse(
sensor["gas"].toString()
) ?? 0;


fall =
sensor["fall"] ?? false;



generateAlerts();



});

}



void generateAlerts() {

  List<Map<String,dynamic>> newAlerts = [];

  if (fall) {

    newAlerts.add({
      "title":"FALL DETECTED",
      "message":"Worker may have fallen",
      "level":"danger"
    });

    NotificationService.showNotification(
      "🚨 FALL DETECTED",
      "Worker may have fallen",
    );
  }

  if (gas > 700) {

    newAlerts.add({
      "title":"HIGH GAS LEVEL",
      "message":"Unsafe gas concentration detected",
      "level":"warning"
    });

    NotificationService.showNotification(
      "⚠ High Gas Level",
      "Unsafe gas concentration detected",
    );
  }

  if (temperature > 35) {

    newAlerts.add({
      "title":"HIGH TEMPERATURE",
      "message":"Temperature exceeded safe limit",
      "level":"warning"
    });

    NotificationService.showNotification(
      "🌡 High Temperature",
      "Temperature exceeded safe limit",
    );
  }

  setState(() {
    alerts = newAlerts;
  });
}





@override
Widget build(BuildContext context){


return Scaffold(


appBar:
AppBar(

title:
const Text(
"Safety Alerts"
),

),



body:

alerts.isEmpty

?

const Center(

child:
Text(

"No Active Alerts",

style:
TextStyle(

fontSize:22,

color:Colors.white70,

),

),

)


:

ListView.builder(


padding:
const EdgeInsets.all(20),


itemCount:
alerts.length,


itemBuilder:
(context,index){


final alert =
alerts[index];



return Container(

margin:
const EdgeInsets.only(
bottom:15,
),


padding:
const EdgeInsets.all(20),



decoration:
BoxDecoration(

color:
alert["level"]=="danger"

?
AppTheme.accentRose

:

AppTheme.accentAmber,


borderRadius:
BorderRadius.circular(20),

),



child:
Row(

children:[


const Icon(

Icons.warning,

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

alert["title"],


style:
const TextStyle(

color:
Colors.white,

fontSize:18,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:6),



Text(

alert["message"],


style:
const TextStyle(

color:
Colors.white70,

),

),



],

),

),



],

),

);



},

),


);



}


}