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
  final locationpackage.Location _location = new locationpackage.Location();
  LocationData _currentLocation;

  bool _liveUpdate = true;
  bool _permission = false;

  @override
  void initState() {
    mapController = MapController();
    initLocationService();
    super.initState();
  }

  initLocationService() async{
    await _location.changeSettings(
      accuracy: locationpackage.LocationAccuracy.HIGH,
      interval: 1000
    );

    LocationData location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _location.serviceEnabled();
      if(serviceEnabled){
        var permission = await _location.requestPermission();
        _permission = permission == locationpackage.PermissionStatus.GRANTED;
        if(_permission){
          location = await _location.getLocation();
          _currentLocation = location;
          _location.onLocationChanged().listen((locationpackage.LocationData result) async{
            if(mounted){
              setState(() {
                _currentLocation = result;

                if(_liveUpdate){
                  mapController.move(LatLng(_currentLocation.latitude, _currentLocation.longitude), mapController.zoom);
                }
              });
            }
          });
        } else {
          serviceRequestResult = await _location.requestService();
          if(serviceRequestResult){
            initLocationService();
            return;
          }
        }
      }
    } on PlatformException catch (e){
      print(e);
      if(e.code == "PERMISSION_DENIED"){
        print(e.message);
      } else if(e.code == "SERVICE_STATUS_ERROR"){
        print(e.message);
      }
      location = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      /*Marker(
        width: 160.0,
        height: 120.0,
        //point: LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
          point: LatLng(28.6000, 77.2000),
        builder: (ctx) => CustomMapUserCard()
      ),*/
    ];

    userLocationOptions = UserLocationOptions(
        context: context,
        updateMapLocationOnPositionChange: false,
        mapController: mapController,
        markers: markers);

    return new FlutterMap(
        options: new MapOptions(
          maxZoom: 20,
          minZoom: 10,
          plugins: [UserLocationPlugin()],
          center: LatLng(widget.userPosition.latitude, widget.userPosition.longitude),
          zoom: 5.0,),
        layers: [
          new TileLayerOptions(
            placeholderImage: AssetImage("assets/loading/map_loader.gif"),
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

  static const String currentTheme = darkTheme;
}
