import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rent_app/authorization/firebase_repository.dart';

abstract class OwnerFirebaseInterface {
// TODO : Funtion to update the existing profile in users with the location and links of images provided by user.
  /// Takes argument : Map<String, dyanmic> userData
  void updateRegistrationProfile(
      Map<String, dynamic> userRegistrationData, String userUid) {

  }

  /// Takes parameter File profileImage
  Future<String> profilePictureUrl(@required File profileImage, String userUid);
}
