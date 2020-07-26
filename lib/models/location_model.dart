import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class LandlordLocationModel {
  final String docId;
  final String geoHash;
  final LatLng latlng;
  final String imageUrl;

  LandlordLocationModel({this.imageUrl, this.docId, this.geoHash, this.latlng});

  // factory LandlordLocationModel.fromFirestore(DocumentSnapshot snapshot) {
  //   Map data = snapshot.data;
  //   return LandlordLocationModel(
  //     geoHash: data["geohash"] ?? "",
  //     location: data["location"]);
  // }
}
