import 'dart:io';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rent_app/geolocator_api/geolocator_provider.dart';
import 'package:rent_app/models/guest_model.dart';
import 'package:rent_app/screen/guest/guest_home.dart';
import 'package:rent_app/style.dart';
import 'package:rent_app/utils/owner_firebase_operation.dart';

class GuestInfoRegisterScreen extends StatefulWidget {
  // Store user collection data for logged in user
  final Map<String, dynamic> userData;
  final String userType;

  const GuestInfoRegisterScreen({Key key, this.userData, this.userType}) : super(key: key);

  @override
  _GuestInfoRegisterScreenState createState() => _GuestInfoRegisterScreenState();
}

class _GuestInfoRegisterScreenState extends State<GuestInfoRegisterScreen> {
  OwnerFirebaseOperation ownerFirebaseOperation = new OwnerFirebaseOperation();

  bool imageUploaded = false;
  bool homeImageUploaded = false;
  List<File> images;
  List<File> homeImages;

  GeolocatorProvider geolocatorProvider = new GeolocatorProvider();
  Map<String, dynamic> locationData;
  bool isLocationLoading = true;
  Color fabColor = Color(0xFFFF2366);
  bool fabVisible = true;

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
      body: PageView(
        controller: pageController,
        physics: BouncingScrollPhysics(),
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
        ],
      ),
      floatingActionButton: fabVisible
          ? new FloatingActionButton(
        onPressed: () async {
          String profileUrl = await ownerFirebaseOperation.profilePictureUrl(images[0], widget.userData["uid"]);
          String profilePictureDownloadUrl =
          await ownerFirebaseOperation.getDownloadUrlProfilePicture(widget.userData["uid"]);
          print("Uploaded profile picture: " + profileUrl);

          GuestProfileSetup model = GuestProfileSetup(
              profilePictureDownloadUrl: profilePictureDownloadUrl,
              profileUrl: profileUrl);

          ownerFirebaseOperation.updateRegistrationProfile(model.toJson(), widget.userData["uid"], widget.userType);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GuestHomeScreen()));
        },
        backgroundColor: fabColor,
        elevation: 10,
        child: Icon(Icons.arrow_forward_ios, color: Colors.white),
      )
          : SizedBox(),
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
        ],
      ),
    );
  }
}
