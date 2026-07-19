import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner:false,

      title:"Smart Safety Vest",

      theme:ThemeData(

        colorScheme:
        ColorScheme.fromSeed(
          seedColor:Colors.blue
        ),

        useMaterial3:true,

      ),

      home:const HomePage(),

    );

  }

}




class HomePage extends StatefulWidget {

  const HomePage({super.key});


  @override
  State<HomePage> createState()=>_HomePageState();

}



class _HomePageState extends State<HomePage>{


  final DatabaseReference db =
  FirebaseDatabase.instance.ref();



  double temperature=0;
  double humidity=0;

  int gas=0;

  int heartRate=0;

  bool fall=false;


  double latitude=0;
  double longitude=0;



  @override
  void initState(){

    super.initState();

    readFirebase();

  }




  void readFirebase(){


    db.onValue.listen((event){


      final data =
      event.snapshot.value as Map<dynamic,dynamic>?;


      if(data==null)return;



      final sensor =
      data["sensor"];



      final gps =
      data["gps"];




      setState((){


        temperature =
        double.tryParse(
            sensor["temperature"].toString()
        ) ?? 0;



        humidity =
        double.tryParse(
            sensor["humidity"].toString()
        ) ?? 0;



        gas =
        int.tryParse(
            sensor["gas"].toString()
        ) ?? 0;



        heartRate =
        int.tryParse(
            sensor["heartRate"].toString()
        ) ?? 0;



        fall =
        sensor["fall"] ?? false;




        latitude =
        double.tryParse(
            gps["latitude"].toString()
        ) ?? 0;



        longitude =
        double.tryParse(
            gps["longitude"].toString()
        ) ?? 0;



      });


    });


  }




  Widget sensorCard(
      String title,
      String value,
      IconData icon,
      Color color
      ){

    return Card(

      elevation:5,

      child:Padding(

        padding:
        const EdgeInsets.all(15),


        child:Column(

          children:[


            Icon(
              icon,
              size:35,
              color:color,
            ),


            const SizedBox(height:10),


            Text(
              title,
              style:
              const TextStyle(
                  fontWeight:
                  FontWeight.bold
              ),
            ),



            Text(

              value,

              style:
              TextStyle(

                fontSize:22,

                fontWeight:
                FontWeight.bold,

                color:color,

              ),

            )

          ],

        ),

      ),

    );

  }






  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:AppBar(

        title:
        const Text(
          "🦺 Smart Safety Vest",
        ),

        centerTitle:true,


      ),



      body:
      SingleChildScrollView(


        child:Padding(

          padding:
          const EdgeInsets.all(12),


          child:Column(

            children:[




              GridView.count(

                shrinkWrap:true,

                physics:
                const NeverScrollableScrollPhysics(),


                crossAxisCount:2,


                children:[



                  sensorCard(
                      "Temperature",
                      "$temperature °C",
                      Icons.thermostat,
                      Colors.red
                  ),



                  sensorCard(
                      "Humidity",
                      "$humidity %",
                      Icons.water_drop,
                      Colors.blue
                  ),



                  sensorCard(
                      "Gas",
                      "$gas",
                      Icons.cloud,
                      Colors.orange
                  ),



                  sensorCard(
                      "Heart Rate",
                      "$heartRate BPM",
                      Icons.favorite,
                      Colors.pink
                  ),



                ],


              ),



              const SizedBox(height:15),



              Card(

                color:
                fall
                    ? Colors.red
                    : Colors.green,


                child:ListTile(


                  leading:
                  const Icon(
                      Icons.warning,
                      color:Colors.white
                  ),


                  title:
                  Text(

                    fall
                        ?
                    "FALL DETECTED!"
                        :
                    "Normal Condition",

                    style:
                    const TextStyle(

                      color:Colors.white,

                      fontSize:20,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                ),

              ),


/*
              const SizedBox(height:20),



              SizedBox(

                height:350,


                child:GoogleMap(


                  initialCameraPosition:

                  CameraPosition(

                    target:
                    LatLng(
                        latitude,
                        longitude
                    ),

                    zoom:16,

                  ),



                  markers:{


                    Marker(

                      markerId:
                      const MarkerId(
                          "worker"
                      ),


                      position:
                      LatLng(
                          latitude,
                          longitude
                      ),


                    )


                  },

                ),


              )

*/

            ],


          ),

        ),


      ),



    );


  }


}