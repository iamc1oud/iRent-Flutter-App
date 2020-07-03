import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/screen/auth/auth.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FlareActor(
            "assets/flare_animations/house.flr",
            alignment: Alignment.center,
            fit: BoxFit.cover,
            animation: "Sun Rotate",
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
                child: AuthScreen()),
          )
        ],
      ),
    );
  }
}
