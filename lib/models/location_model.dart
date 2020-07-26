import 'package:cloud_firestore/cloud_firestore.dart';

class LandlordLocationModel {
  final String docId;
  final String geoHash;
  final GeoPoint location;

  LandlordLocationModel({this.docId, this.geoHash, this.location});

  factory LandlordLocationModel.fromFirestore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    return LandlordLocationModel(
      geoHash: data["geohash"] ?? "",
      location: data["location"]
    );
  }
}