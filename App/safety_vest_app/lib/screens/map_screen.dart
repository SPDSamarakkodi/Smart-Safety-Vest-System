import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../theme/app_theme.dart';



class MapScreen extends StatefulWidget {

  const MapScreen({super.key});


  @override
  State<MapScreen> createState()
      => _MapScreenState();

}



class _MapScreenState
    extends State<MapScreen>
    with TickerProviderStateMixin {


late final AnimatedMapController mapController;

StreamSubscription<DatabaseEvent>? _gpsSubscription;
final DatabaseReference db =
FirebaseDatabase.instance.ref();



double latitude = 0;

double longitude = 0;



@override
void initState(){

super.initState();


mapController =
AnimatedMapController(
vsync:this,
);


readGPS();

}




void readGPS(){


_gpsSubscription = db.onValue.listen((event){


final data =
event.snapshot.value
as Map<dynamic,dynamic>?;



if(data == null)return;



final gps =
data["gps"];



if(gps == null)return;



if (!mounted) return;

setState((){

latitude =
double.tryParse(
gps["latitude"].toString()
) ?? 0;

longitude =
double.tryParse(
gps["longitude"].toString()
) ?? 0;

});



if(latitude !=0 &&
longitude !=0){


mapController.animateTo(

dest:
LatLng(
latitude,
longitude,
),

zoom:18,

);


}



});


}





@override
Widget build(BuildContext context){


return Scaffold(


appBar:
AppBar(

title:
const Text(
"Live Worker Location"
),

),



body:
Stack(


children:[



FlutterMap(

mapController:
mapController.mapController,


options:
MapOptions(

initialCenter:
LatLng(
latitude,
longitude,
),

initialZoom:15,

),



children:[



TileLayer(

urlTemplate:
'https://tile.openstreetmap.org/{z}/{x}/{y}.png',


userAgentPackageName:
'com.smart.safety.vest',

),



MarkerLayer(

markers:[


Marker(

point:
LatLng(
latitude,
longitude,
),


width:60,

height:60,


child:
const Icon(

Icons.person_pin_circle,

color:
Colors.red,

size:50,

),


),


],


),


],


),




Positioned(

bottom:25,

right:20,


child:
FloatingActionButton.extended(


backgroundColor:
AppTheme.accentBlue,


onPressed:(){


if(latitude!=0 &&
longitude!=0){


mapController.animateTo(

dest:
LatLng(
latitude,
longitude,
),

zoom:18,

);


}


},


label:
const Text(
"Locate"
),


icon:
const Icon(
Icons.my_location,
),


),


),




],


),


);



}




@override
void dispose() {

  _gpsSubscription?.cancel();

  mapController.dispose();

  super.dispose();

}


}