import 'package:flutter/material.dart';
import 'package:rent_app/screen/homescreen/home.dart';
import 'package:rent_app/screen/splash_screen.dart';
import 'package:rent_app/style.dart';

void main(){
  // TODO: Implement shared preferences for theme settings
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/homescreen' : (context) => HomeScreen()
      },
      theme: new ThemeData(
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppStyle().secondaryTextColor
        ),
        primaryColor: Colors.indigo,
        secondaryHeaderColor: Colors.black
      ),
      home: SplashScreen(),
    );
  }
}
