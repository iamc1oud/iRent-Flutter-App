import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_app/authorization/firebase_repository.dart';
import 'package:rent_app/const.dart';
import 'package:rent_app/models/location_model.dart';
import 'package:rent_app/screen/auth/auth.dart';
import 'package:rent_app/screen/splash_screen.dart';

class SettingWidget extends StatelessWidget {
  @required
  final BuildContext ctx;

  SettingWidget({Key key, this.ctx}) : super(key: key);

  final FirebaseRepository repository = new FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return settingsWidget(this.ctx);
  }

  TextStyle textStyle = GoogleFonts.oxygen();

  Widget settingsWidget(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(Constants().defaultImageUrl))),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "IamCloud.Dev",
            style: GoogleFonts.oxygen(fontWeight: FontWeight.bold),
          ),
        ),
        new SizedBox(height: 50,),
        notificationButton(),
        darkModeButton(),
        shareLocationButton(),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        aboutButton(),
        logoutButton(),
      ],
    );
  }

  // Dark mode button
  Widget darkModeButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(Icons.brightness_2),
              new SizedBox(
                width: 10,
              ),
              new Text(
                "Dark mode",
                style: textStyle,
              )
            ],
          ),
          Switch(
              value: false,
              onChanged: (val) {
                print(val);
              })
        ],
      ),
    );
  }

  // Favorite button
  Widget favoriteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: new Row(
        children: <Widget>[
          new Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          new SizedBox(
            width: 10,
          ),
          new Text(
            "Favorite",
            style: textStyle,
          )
        ],
      ),
    );
  }

  // About button
  Widget aboutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(
                Icons.info_outline,
                color: Colors.blue,
              ),
              new SizedBox(
                width: 10,
              ),
              new Text(
                "About",
                style: textStyle,
              )
            ],
          ),
        ],
      ),
    );
  }

// Notification button
  Widget notificationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(Icons.notifications_none, color: Colors.deepOrange,),
              new SizedBox(
                width: 10,
              ),
              new Text(
                "Notification",
                style: textStyle,
              )
            ],
          ),
          Switch(
              value: true,
              onChanged: (val) {
                print(val);
              })
        ],
      ),
    );
  }

// Share location on map
  Widget shareLocationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(Icons.location_on, color: Colors.teal,),
              new SizedBox(
                width: 10,
              ),
              new Text(
                "Location",
                style: textStyle,
              )
            ],
          ),
          Switch(
              value: true,
              onChanged: (val) {
                print(val);
              })
        ],
      ),
    );
  }

  // Widget logoutButton
  Widget logoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: OutlineButton(
          splashColor: Colors.white,
          highlightedBorderColor: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          onPressed: () {
            repository.logOut().then((value) => Navigator.pushReplacement(
                ctx, MaterialPageRoute(builder: (ctx) => SplashScreen())));
            print("Log out");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: new Text("Logout"),
          ),
        ),
      ),
    );
  }
}
