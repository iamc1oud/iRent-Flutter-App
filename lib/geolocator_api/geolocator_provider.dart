import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rent_app/geolocator_api/geolocator_interface.dart';

class GeolocatorProvider extends GeoLocatorInterface with ChangeNotifier {
  static Position currentPosition;
  static List<Placemark> placemarksNearby;

  Future<Map<String, dynamic>> get placemarks => getCurrentPositionPlacemark();

  @override
  Future<Position> getCurrentLocationLatLng() async {
    // TODO: implement getCurrentLocationLatLng
    currentPosition = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );
    return currentPosition;
  }

  @override
  Future<Map<String, dynamic>> getCurrentPositionPlacemark() async {
    // TODO: implement getCurrentPositionPlacemark
    await this.getCurrentLocationLatLng();
    placemarksNearby = await Geolocator().placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
      for (var value in placemarksNearby) {
        print(value.toJson());
      }
    return placemarksNearby[0].toJson();
  }

}