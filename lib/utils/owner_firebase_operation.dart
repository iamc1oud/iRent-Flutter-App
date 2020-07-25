import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rent_app/utils/owner_firebase_interface.dart';

class OwnerFirebaseOperation extends OwnerFirebaseInterface {

  Future<void> storeLocationWithUid(Map<String, dynamic> userRegistrationData, String uid) async {
    try {

      Firestore.instance.collection("location").document().setData({
        "latitude" : userRegistrationData["latitude"],
        "longitude" : userRegistrationData["longitude"],
        "uid" : uid
      });
    }
    catch (e) {
      print("Error occured ::::: " + e.toString());
    }
  }

  @override
  Future<void> updateRegistrationProfile(Map<String, dynamic> userRegistrationData, String userUid, String userType) async {
    // Find document for current userUid
    try {
      await Firestore.instance
          .collection("user")
          .where("uid", isEqualTo: userUid)
          .reference()
          .getDocuments()
          .then((value) => value.documents[0].reference)
          .then((postRef) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(postRef);
          if (snapshot.exists) {
            await transaction.update(postRef, userRegistrationData);
          }
        });
      });

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<String> profilePictureUrl(File profileImage, String userUid) async {
    // Profile url is generated after uploading to firebase storage
    StorageReference storageReference =
        FirebaseStorage().ref().child("rentAppUserProfilePic/${userUid}_profile_pic.png");
    StorageUploadTask uploadTask = storageReference.putFile(profileImage);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    return snapshot.storageMetadata.path;
  }

  @override
  // ignore: missing_return
  Future<bool> uploadHomePicture(List<File> homeImages, String uid) async {
    try {
      for(int i = 0; i < homeImages.length; i++){
        StorageReference storageReference = FirebaseStorage().ref().child("homeImages/${uid}_home_${i.toString()}");
        storageReference.putFile(homeImages[i]);
      }
      return true;
    } catch (e){
      print("Error found:::::: " + e.toString());
    }

  }

  @override
  Future<String> getDownloadUrlProfilePicture(String userUid) async {
    StorageReference storageReference =
        FirebaseStorage().ref().child("rentAppUserProfilePic/${userUid}_profile_pic.png");

    var link = await storageReference.getDownloadURL();
    return link;
  }
}
