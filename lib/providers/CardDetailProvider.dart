import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/models/map_marker_user_model.dart';

class UserDataProvider {
  String uid;

  bool isLoaded = false;
  Firestore _db = Firestore.instance;
  DocumentSnapshot docSnapshot;

  DocumentSnapshot get userData => docSnapshot;

  Future<DocumentSnapshot> getUserData(String uid) async{
    QuerySnapshot snapshot = await _db
        .collection("user")
        .where("uid", isEqualTo: this.uid)
        .getDocuments();
         docSnapshot = snapshot.documents[0];
    return docSnapshot;
  }
}
