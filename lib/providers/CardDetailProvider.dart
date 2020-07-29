import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  String uid;

  void setUid(String uid) {
    this.uid = uid;
  }

  bool isLoaded = false;
  Firestore _db = Firestore.instance;
  DocumentSnapshot docSnapshot;

  DocumentSnapshot get userData => docSnapshot;

  void getUserData(){
    _db.collection("user").where("uid", isEqualTo: this.uid).getDocuments().then((value) {
      docSnapshot = value.documents[0];
    });
    notifyListeners();
  }

}