import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlareActor(
            "assets/flare_animations/house.flr",
            alignment: Alignment.center,
            fit: BoxFit.cover,
            animation: "Sun Rotate",
          ),
        ],
      ),
    );
  }
}
