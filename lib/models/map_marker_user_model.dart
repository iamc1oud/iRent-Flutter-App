import 'package:cloud_firestore/cloud_firestore.dart';

class MapMarkerUserModel {
  final String name;
  final String imageUrl;
  final List<String> galleryPhotos;
  final String emailId;
  final String address;

  MapMarkerUserModel({this.name, this.imageUrl, this.galleryPhotos, this.emailId, this.address});

  factory MapMarkerUserModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;

    return MapMarkerUserModel(

    );
  }
}