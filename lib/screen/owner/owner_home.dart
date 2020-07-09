import 'dart:io';

import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/style.dart';

class OwnerHomeScreen extends StatefulWidget {
  // Store user collection data for logged in user
  final Map<String, dynamic> userData;

  const OwnerHomeScreen({Key key, this.userData}) : super(key: key);

  @override
  _OwnerHomeScreenState createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  bool imageUploaded = false;
  List<File> images;
  void takeImage(BuildContext context)async{
    images = await ChristianPickerImage.pickImages(maxImages: 1);
    setState(() {
      images.length!= 0 ? imageUploaded = true : imageUploaded = false;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: AppStyle().headingBackgroundColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Welcome,",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                TextSpan(
                                  text: " ${widget.userData["firstname"]}",
                                  style: TextStyle(
                                    fontSize: 26
                                  )
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            preferredSize: Size.fromHeight(100)),
    body: PageView(
      children: <Widget>[
        uploadProfilePictureWidget(),
        new Text("Add photos of home")
      ],
    ),);
  }

  Widget uploadProfilePictureWidget(){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Upload profile picture",
          style: AppTextStyle().cardHeadingPrimaryStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                _pickImage(context);
              },
              child: imageUploaded ? new Container(
                height: size.height * 0.25,
                width: size.width * 0.33,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FittedBox(
                    fit: BoxFit.cover,
                      child: Image.file(images[0])),
                ),
              ) : new Container(
                height: size.height * 0.25,
                width: size.width * 0.33,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.photo_camera, color: Colors.white,),
                    new Text("Upload pcture", style: TextStyle(
                      color: Colors.white
                    ),)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ),

          new Text("Permission for location",
              style: AppTextStyle().cardHeadingPrimaryStyle),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: new Container(
              height: size.height * 0.4,
              width: size.width * 0.9,
              /*child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.location_on, color: Colors.white,),
                  new Text("Location map", style: TextStyle(
                      color: Colors.white
                  ),)
                ],
              ),
              */
              child: MapBoxScreen(),
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  boxShadow: [BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.2)
                  )],
              ),
            ),
          ),
        ),
      ),


        ],
      ),
    );
  }
}
