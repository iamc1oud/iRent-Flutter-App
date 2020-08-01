import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rent_app/authorization/firebase_repository.dart';
import 'package:rent_app/models/map_marker_user_model.dart';

abstract class OwnerFirebaseInterface {
// TODO : Funtion to update the existing profile in users with the location and links of images provided by user.
  /// Takes argument : Map<String, dyanmic> userData
  void updateRegistrationProfile(Map<String, dynamic> userRegistrationData, String userUid, String userType) {}

  /// Takes parameter File profileImage
  Future<String> profilePictureUrl(@required File profileImage, String userUid);

  /// Extract download link of profile image from storage bucket
  Future<String> getDownloadUrlProfilePicture(String userUid);

  /// Extract download link of home images from storage bucket
  Future<String> getHomeUrl(String uid, int photo_number);

  /// Upload residence pictures to firebase collection
  /// Format is : homeImages/${uid}_home_${i.toString()}
  /// Returns true on complete.
  Future<bool> uploadHomePicture(List<File> homeImages, String uid);

  /// Return the dota about the tapped marker user in Custom Card Marker on top of Map screen
  Stream<MapMarkerUserModel> streamMapMarkerUserModel(String id);
}
