import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rent_app/utils/owner_firebase_interface.dart';

class OwnerFirebaseOperation extends OwnerFirebaseInterface {
  @override
  Future<void> updateRegistrationProfile(
      Map<String, dynamic> userRegistrationData, String userUid) async {
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
    }
    catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<String> profilePictureUrl(File profileImage, String userUid) async {
    // Profile url is generated after uploading to firebase storage
    StorageReference storageReference = FirebaseStorage()
        .ref()
        .child("rentAppUserProfilePic/${userUid}_profile_pic.png");
    StorageUploadTask uploadTask = storageReference.putFile(profileImage);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    return snapshot.storageMetadata.path;
  }
}
