import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class MapBoxScreen extends StatefulWidget {
  final Position userPosition;

  const MapBoxScreen({Key key, this.userPosition}) : super(key: key);

  @override
  _MapBoxScreenState createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  MapController mapController;
  UserLocationOptions userLocationOptions;
  List<Marker> markers;

  @override
  void initState() {
    mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
        builder: (ctx) => Container(
          child: FlutterLogo(
            colors: Colors.blue,
            key: ObjectKey(Colors.blue),
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => Container(
          child: FlutterLogo(
            colors: Colors.green,
            key: ObjectKey(Colors.green),
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => Container(
          child: FlutterLogo(
            colors: Colors.purple,
            key: ObjectKey(Colors.purple),
          ),
        ),
      ),
    ];
    userLocationOptions = UserLocationOptions(
        showMoveToCurrentLocationFloatingActionButton: true,
        context: context,
        zoomToCurrentLocationOnLoad: true,
        mapController: mapController,
        markers: markers);

    return new FlutterMap(
      options: new MapOptions(minZoom: 5.0, maxZoom: 15.0, plugins: [UserLocationPlugin()]),
      layers: [
        new TileLayerOptions(
          urlTemplate: MapStyles.currentTheme,
          additionalOptions: {
            'accessToken': 'sk.eyJ1IjoiY2xvdWRtYXgiLCJhIjoiY2s3YzJzdnN5MGlxMzNxbXJkZXJ0N3RvYyJ9.CwnAoKlXU6qiva_nqqT1mA',
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

  static const String currentTheme = lightTheme;
}
