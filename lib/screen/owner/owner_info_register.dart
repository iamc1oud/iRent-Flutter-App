import 'dart:io';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/geolocator_api/geolocator_provider.dart';
import 'package:rent_app/models/owner_model.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/style.dart';
import 'package:rent_app/utils/owner_firebase_operation.dart';

import 'owner_home.dart';

class OwnerInfoRegisterScreen extends StatefulWidget {
  // Store user collection data for logged in user
  final Map<String, dynamic> userData;
  final String userType;

  const OwnerInfoRegisterScreen({Key key, this.userData, this.userType}) : super(key: key);

  @override
  _OwnerInfoRegisterScreenState createState() => _OwnerInfoRegisterScreenState();
}

class _OwnerInfoRegisterScreenState extends State<OwnerInfoRegisterScreen> {
  OwnerFirebaseOperation ownerFirebaseOperation = new OwnerFirebaseOperation();

  bool imageUploaded = false;
  bool homeImageUploaded = false;
  List<File> images;
  List<File> homeImages;

  GeolocatorProvider geolocatorProvider = new GeolocatorProvider();
  Map<String, dynamic> locationData;
  bool isLocationLoading = true;
  Color fabColor = Color(0xFFFF2366);
  bool fabVisible = false;

  // Page controller for profile setup process
  PageController pageController = new PageController(viewportFraction: 0.9);

  // Store current position of user during registration
  Position currentPosition;

  void takeImage(BuildContext context) async {
    images = await ChristianPickerImage.pickImages(maxImages: 1);
    setState(() {
      images.length != 0 ? imageUploaded = true : imageUploaded = false;
    });
    Navigator.of(context).pop();
  }

  void uploadHomePicture(BuildContext context) async {
    homeImages = await ChristianPickerImage.pickImages(maxImages: 5);

    setState(() {
      homeImages.length != 0 ? homeImageUploaded = true : homeImageUploaded = false;
    });
    Navigator.of(context).pop();
  }

  Future _pickImage(BuildContext context) async {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          takeImage(context);
          return Center();
        });
  }

  Future _pickHomeImage(BuildContext context) async {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          uploadHomePicture(context);
          return Center();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userData);
    getLocation();
  }

  getLocation() async {
    var locationInfo = await geolocatorProvider.getCurrentPositionPlacemark();
    setState(() {
      locationData = locationInfo;
      isLocationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              padding: EdgeInsets.only(left: 30.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Profile",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoSlab",
                                    color: Colors.black)),
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          preferredSize: Size.fromHeight(70)),
      body: isLocationLoading
          ? Center(
              child: new FittedBox(
                child: Image.asset(
                  "assets/loading/loader.gif",
                  fit: BoxFit.cover,
                ),
              ),
            )
          : PageView(
              controller: pageController,
              physics: BouncingScrollPhysics(),
              onPageChanged: (position) {
                if (position == 1) {
                  setState(() {
                    fabVisible = true;
                    fabColor = Color(0xFF006AAE);
                  });
                } else {
                  setState(() {
                    fabVisible = false;
                    fabColor = Color(0xFFFF2366);
                  });
                }
              },
              pageSnapping: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFF2366),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)]),
                      child: uploadProfilePictureWidget()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF006AAE),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)]),
                      child: uploadHomeImages()),
                )
              ],
            ),
      floatingActionButton: fabVisible
          ? new FloatingActionButton(
              onPressed: () async {
                print(widget.userData["uid"]);
                String profileUrl = await ownerFirebaseOperation.profilePictureUrl(images[0], widget.userData["uid"]);
                String dpDownloadUrl =
                    await ownerFirebaseOperation.getDownloadUrlProfilePicture(widget.userData["uid"]);
                print("Uploaded profile picture: " + profileUrl);

                OwnerProfileSetup model = OwnerProfileSetup(
                    countryISOCode: locationData["isoCountryCode"],
                    latitude: locationData["position"]["latitude"],
                    longitude: locationData["position"]["longitude"],
                    locality: locationData["locality"],
                    subLocality: locationData["subLocality"],
                    profilePictureDownloadUrl: dpDownloadUrl,
                    profileUrl: profileUrl);

                print("updating registration profile");
                await ownerFirebaseOperation.updateRegistrationProfile(
                    model.toJson(), widget.userData["uid"], widget.userType);

                print("Uploading home pictures");
                await ownerFirebaseOperation.uploadHomePicture(homeImages, widget.userData["uid"]);

                print("Operation:::: Updating location collection with following parameters:");
                print("Latitude :" + locationData["position"]["latitude"].toString());
                print("Longitude :" + locationData["position"]["longitude"].toString());
                print("profileImage :" + model.profilePictureDownloadUrl);

                await ownerFirebaseOperation.storeLocationWithUid({
                  "latitude": locationData["position"]["latitude"],
                  "longitude": locationData["position"]["longitude"],
                  "profileImage": model.profilePictureDownloadUrl
                }, widget.userData["uid"]);

                // New map data
                widget.userData.addAll({
                  "countryISOCode": locationData["isoCountryCode"],
                  'latitude': locationData["position"]["latitude"],
                  'longitude': locationData["position"]["longitude"],
                  'locality': locationData["locality"],
                  'subLocality': locationData["subLocality"],
                  'profilePictureDownloadUrl': dpDownloadUrl,
                  'profileUrl': profileUrl
                });

                // After registration navigate to homescreen
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OwnerHome(
                              currentUserData: widget.userData,
                            )));
              },
              backgroundColor: fabColor,
              elevation: 10,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            )
          : SizedBox(),
    );
  }

  Widget uploadHomeImages() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: InkWell(
        onTap: () {
          _pickHomeImage(context);
          print(homeImages);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Residence picture",
              style: AppTextStyle().cardHeadingPrimaryStyle,
            ),
            homeImageUploaded
                ? Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: homeImages
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  height: size.height * 0.25,
                                  width: size.width * 0.33,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FittedBox(fit: BoxFit.cover, child: Image.file(e)),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      shadowColor: Color(0xFF006AAE),
                      borderRadius: BorderRadius.circular(20),
                      child: new Container(
                        height: size.height * 0.25,
                        width: size.width * 0.33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                            new Text(
                              "Upload picture",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFF006AAE),
                            boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 2, spreadRadius: 1)],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget uploadProfilePictureWidget() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: <Widget>[
          new Text("Upload profile picture", style: AppTextStyle().cardHeadingPrimaryStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _pickImage(context);
              },
              child: imageUploaded
                  ? new Container(
                      height: size.height * 0.25,
                      width: size.width * 0.33,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FittedBox(fit: BoxFit.cover, child: Image.file(images[0])),
                      ),
                    )
                  : Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5,
                      shadowColor: Colors.transparent,
                      child: new Container(
                        height: size.height * 0.25,
                        width: size.width * 0.33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                            new Text(
                              "Upload picture",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFFFF2366),
                            boxShadow: [BoxShadow(color: Colors.pink, spreadRadius: 2, blurRadius: 10)],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
            ),
          ),
          new Text("Current location", style: AppTextStyle().cardHeadingPrimaryStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: new Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Country: " + locationData["isoCountryCode"],
                      style: AppTextStyle().whiteTextColor,
                    ),
                    new Text(
                      "Sublocality: " + locationData["subLocality"] == ""
                          ? "Not avaiable"
                          : locationData["subLocality"],
                      style: AppTextStyle().whiteTextColor,
                    ),
                    new Text(
                      "Locality: " + locationData["locality"],
                      style: AppTextStyle().whiteTextColor,
                    ),
                    /*new Text(
                      "Latitude: " + locationData["position"]["latitude"].toString(),
                      style: AppTextStyle().whiteTextColor,
                    ),
                    new Text(
                      "Longitude: " + locationData["position"]["longitude"].toString(),
                      style: AppTextStyle().whiteTextColor,
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: Container(
                height: 200,
                child: MapBoxScreen(
                  userPosition: Position(
                      latitude: locationData["position"]["latitude"], longitude: locationData["position"]["longitude"]),
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
