import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'alerts_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';


class MainNavigation extends StatefulWidget {

  const MainNavigation({super.key});


  @override
  State<MainNavigation> createState()
  => _MainNavigationState();

}



class _MainNavigationState
extends State<MainNavigation>{


  int currentIndex = 0;


  final pages = [

    const DashboardScreen(),

    const MapScreen(),

    const AlertsScreen(),

    const HistoryScreen(),

    const ProfileScreen(),

  ];



  @override
  Widget build(BuildContext context){


    return Scaffold(

      body: pages[currentIndex],


      bottomNavigationBar:
      NavigationBar(

        selectedIndex:
        currentIndex,


        onDestinationSelected:
        (index){

          setState((){

            currentIndex=index;

          });

        },


        destinations: const [


          NavigationDestination(

            icon:
            Icon(Icons.home_outlined),

            selectedIcon:
            Icon(Icons.home),

            label:"Home",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.map_outlined),

            selectedIcon:
            Icon(Icons.map),

            label:"Map",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.warning_outlined),

            selectedIcon:
            Icon(Icons.warning),

            label:"Alerts",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.history_outlined),

            selectedIcon:
            Icon(Icons.history),

            label:"History",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.person_outline),

            selectedIcon:
            Icon(Icons.person),

            label:"Profile",

          ),


        ],

      ),

    );

  }

}