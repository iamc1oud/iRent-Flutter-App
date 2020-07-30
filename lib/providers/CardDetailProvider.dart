import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  String uid;

  bool isLoaded = false;
  Firestore _db = Firestore.instance;
  DocumentSnapshot docSnapshot;

  DocumentSnapshot get userData => docSnapshot;

  void getUserData(String uid) {
    _db
        .collection("user")
        .where("uid", isEqualTo: this.uid)
        .getDocuments()
        .then((value) {
      docSnapshot = value.documents[0];
    });
    print(docSnapshot.data);
    /*{profileUrl: rentAppUserProfilePic/imIA5CsyAdMioguzXemaKQ3nnFF3_profile_pic.png,
    isOwnerOrGuest: user_landlord, uid: imIA5CsyAdMioguzXemaKQ3nnFF3,
    firstname: Ajay, subLocality: Aya Nagar, countryISOCode: IN,
     latitude: 28.470294,
     profilePictureDownloadUrl: https://img.redbull.com/images/c_crop,x_511,y_0,h_973,w_778/c_fill,w_860,h_1075/q_auto,f_auto/redbullcom/2020/4/15/ybllzd5vwdfnll6jgbzp/valorant-raze,
     isRegistered: true, email: ajay@gmail.com,
      lastname: Singh,
      longitude: 77.1248861}*/
    notifyListeners();
  }
}
