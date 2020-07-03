import 'package:flutter/material.dart';
import 'package:rent_app/screen/splash_screen.dart';

void main(){
  // TODO: Implement shared preferences for theme settings
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.indigo,
        secondaryHeaderColor: Colors.black
      ),
      home: SplashScreen(),
    );
  }
}
