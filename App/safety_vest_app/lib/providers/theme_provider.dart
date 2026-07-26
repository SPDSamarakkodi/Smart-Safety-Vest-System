import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier{


ThemeMode themeMode = ThemeMode.dark;


bool get isDark =>
themeMode == ThemeMode.dark;



ThemeProvider(){

loadTheme();

}



void toggleTheme(bool value) async{


themeMode =
value
?
ThemeMode.dark
:
ThemeMode.light;



notifyListeners();



final prefs =
await SharedPreferences.getInstance();


await prefs.setBool(
"darkMode",
value
);


}



void loadTheme() async{


final prefs =
await SharedPreferences.getInstance();


final dark =
prefs.getBool("darkMode") ?? true;



themeMode =
dark
?
ThemeMode.dark
:
ThemeMode.light;



notifyListeners();


}


}