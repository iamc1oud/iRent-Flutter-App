import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:rent_app/authorization/firebase_repository.dart';
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

  Stream<List<LandlordLocationModel>> streamLandlordLocations(){
    Firestore firestore = Firestore.instance;
    GeoFirestore geoFirestore = GeoFirestore(firestore.collection('location'));
    final queryLocation = GeoPoint(28.470294, 77.1248861);
    StreamController<LandlordLocationModel> streamController = StreamController.broadcast();

    List<LandlordLocationModel> result;
    streamController.stream.listen((event) {
      result.add(event);
      print(event);
    });


  }

  Widget settingsWidget(BuildContext ctx) {

    return Column(
      children: <Widget>[new RaisedButton(
        onPressed: () async {
          streamLandlordLocations().listen((event) {
            print(event);
          });
          // creates a new query around [37.7832, -122.4056] with a radius of 0.6 kilometers
    /*      final List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(queryLocation, 50);
          documents.forEach((document) {
            print(document.data);
          });
    */      print("Log out");
        },
        child: new Text("Find location"),
      ),
        new RaisedButton(
          onPressed: () {
            repository.logOut().then((value) => Navigator.pushReplacement(
                ctx, MaterialPageRoute(builder: (ctx) => SplashScreen())));
            print("Log out");
          },
          child: new Text("Log out"),
        )
      ],
    );
  }
}
