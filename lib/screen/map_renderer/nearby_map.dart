import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/models/location_model.dart';
import 'package:rent_app/components/custom_map_user_marker.dart';
import 'package:rent_app/providers/theme_provider.dart';
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
  List<LandlordLocationModel> newPoints = [];

  final queryLocation = GeoPoint(28.470294, 77.1248861);

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
    List<DocumentSnapshot> result = await geoFirestore.getAtLocation(queryLocation, 50);
    for (int i = 0; i < result.length; i++) {
      LatLng latlng = LatLng(
        result[i].data["location"].latitude,
        result[i].data["location"].longitude,
      );
      LandlordLocationModel obj =
          new LandlordLocationModel(docId: result[i].documentID, latlng: latlng, imageUrl: result[i].data["imageUrl"]);

      print(result[i].data);
      setState(() {
        newPoints.add(obj);
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
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    var markers = newPoints.map((obj) {
      return Marker(
          width: 50,
          height: 50,
          point: obj.latlng,
          builder: (context) => Container(
                child: CustomMapUserMarker(
                  docId: obj.docId,
                  imageUrl: obj.imageUrl,
                ),
              ));
    }).toList();

    userLocationOptions = UserLocationOptions(
        showMoveToCurrentLocationFloatingActionButton: true,
        context: context,
        updateMapLocationOnPositionChange: false,
        mapController: mapController,
        markers: markers);

    return Scaffold(
      body: new FlutterMap(
        options: new MapOptions(
          maxZoom: 20,
          minZoom: 10,
          plugins: [UserLocationPlugin()],
          center: LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
          zoom: 5.0,
        ),
        layers: [
          new TileLayerOptions(
            //placeholderImage: AssetImage("assets/loading/map_loader.gif"),

            urlTemplate: provider.isLightTheme ? MapStyles.lightTheme : MapStyles.darkTheme,
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
      ),
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
