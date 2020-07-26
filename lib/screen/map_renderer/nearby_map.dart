import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as locationpackage;
import 'package:location/location.dart';
import 'package:rent_app/components/custom_map_user_card.dart';
import 'package:user_location/user_location.dart';

class NearbyMapScreen extends StatefulWidget {
  final Position userPosition;

  const NearbyMapScreen({Key key, this.userPosition}) : super(key: key);

  @override
  _NearbyMapScreenState createState() => _NearbyMapScreenState();
}

class _NearbyMapScreenState extends State<NearbyMapScreen> {
  MapController mapController;
  UserLocationOptions userLocationOptions;
  List<Marker> markers;
  final queryLocation = GeoPoint(28.470294, 77.1248861);
  final locationpackage.Location _location = new locationpackage.Location();
  LocationData _currentLocation;

  bool _liveUpdate = true;
  bool _permission = false;
  Firestore firestore = Firestore.instance;
  GeoFirestore geoFirestore;
  @override
  void initState() {
    mapController = MapController();

    geoFirestore = GeoFirestore(firestore.collection('location'));
    fetchLocations();
    super.initState();
  }

  fetchLocations() async {
    List<DocumentSnapshot> result =
        await geoFirestore.getAtLocation(queryLocation, 50);
    print(result);
    for (int i = 0; i < result.length; i++) {
      setState(() {
        markers.add(Marker(
            point: LatLng(result[0].data["location"].latitude,
                result[0].data["location"].longitude),
            builder: (context) => Icon(
                  Icons.airline_seat_legroom_normal,
                  size: 50,
                ),
            height: 100,
            width: 100));
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
        showMoveToCurrentLocationFloatingActionButton: true,
        context: context,
        updateMapLocationOnPositionChange: false,
        mapController: mapController,
        markers: markers);

    return new FlutterMap(
      options: new MapOptions(
        maxZoom: 20,
        minZoom: 10,
        plugins: [UserLocationPlugin()],
        center:
            LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
        zoom: 5.0,
      ),
      layers: [
        new TileLayerOptions(
          placeholderImage: AssetImage("assets/loading/map_loader.gif"),
          urlTemplate: MapStyles.currentTheme,
          additionalOptions: {
            'accessToken':
                'sk.eyJ1IjoiY2xvdWRtYXgiLCJhIjoiY2s3YzJzdnN5MGlxMzNxbXJkZXJ0N3RvYyJ9.CwnAoKlXU6qiva_nqqT1mA',
            'id': 'mapbox.mapbox-streets-v7'
          },
        ),
        MarkerLayerOptions(
          markers: markers,
        ),
        userLocationOptions
      ],
      mapController: mapController,
    );
  }
}

class MapStyles {
  static const String lightTheme =
      "https://api.mapbox.com/styles/v1/cloudmax/ck7gad8b306w61iqyejgl3502/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2xvdWRtYXgiLCJhIjoiY2pxbWE4OXlmMHhrbTQzbGY0ZDB6OTBrdyJ9.4TILrjtq1v5eCmMwsbbotQ";
  static const String darkTheme =
      "https://api.mapbox.com/styles/v1/cloudmax/ck7c2vd9t03j31iqura6hp5p4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2xvdWRtYXgiLCJhIjoiY2pxbWE4OXlmMHhrbTQzbGY0ZDB6OTBrdyJ9.4TILrjtq1v5eCmMwsbbotQ";

  static const String currentTheme = darkTheme;
}
