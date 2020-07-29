import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/const.dart';
import 'package:rent_app/providers/CardDetailProvider.dart';
import 'package:shimmer/shimmer.dart';

class CustomMapUserCard extends StatelessWidget {
  // We wll need the user uid only to fetch data from firebase
  final String uid;

  // Use provider here
  static bool isLoaded = false;

  const CustomMapUserCard({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: isLoaded
          ?  Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Some name",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "RobotoSlab"),
                        ),
                        new CircleAvatar(
                          backgroundImage:
                              NetworkImage(Constants().defaultImageUrl),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: new Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoSlab"),
                      ),
                    ),
                    galleryWidget(context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: new Text("Email Id",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "RobotoSlab")),
                    ),
                  ],
                ),

          )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      placeHolderNameWidget(),
                      placeHolderProfileWidget()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: new Text(
                      "Gallery",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "RobotoSlab"),
                    ),
                  ),
                  placeHolderGalleryWidget(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: new Text("Email Id",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoSlab")),
                  ),
                  placeHolderNameWidget(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: new Text("Address",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoSlab")),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      placeHolderNameWidget(),
                      new SizedBox(
                        height: 5,
                      ),
                      placeHolderNameSecondaryWidget()
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new FloatingActionButton.extended(
          backgroundColor: Colors.indigoAccent,
          onPressed: () {
            Firestore _db = Firestore.instance;
            _db
                .collection("user")
                .where("uid", isEqualTo: this.uid)
                .getDocuments()
                .then((value) => print(value.documents[0].data));

            StorageReference storageReference = FirebaseStorage()
                .ref()
                .child("homeImages/${this.uid}_home_1");
            print(storageReference.path);
          },
          label: Icon(Icons.call),
        ),
      ),
    );
  }

  Widget galleryWidget(BuildContext ctx) {
    return Container(
      height: MediaQuery.of(ctx).size.height * 0.5,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, pos) {
            return Container(
              width: 180,
              child: Card(
                child: Center(child: new Text(pos.toString())),
              ),
            );
          }),
    );
  }

  Widget placeHolderNameWidget() {
    return Container(
        child: Shimmer.fromColors(
            baseColor: Constants().baseColor,
            highlightColor: Constants().highlightColor,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 160,
              height: 28.0,
            )));
  }

  Widget placeHolderNameSecondaryWidget() {
    return Container(
      child: Shimmer.fromColors(
          baseColor: Constants().baseColor,
          highlightColor: Constants().highlightColor,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            height: 28,
          )),
    );
  }

  Widget placeHolderProfileWidget() {
    return Container(
        child: Shimmer.fromColors(
            baseColor: Constants().baseColor,
            highlightColor: Constants().highlightColor,
            child: CircleAvatar(
              backgroundColor: Colors.white,
            )));
  }

  Widget placeHolderGalleryWidget(BuildContext ctx) {
    return Container(
      height: MediaQuery.of(ctx).size.height * 0.5,
      child: Shimmer.fromColors(
        baseColor: Constants().baseColor,
        highlightColor: Constants().highlightColor,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, pos) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Center(child: new Text(pos.toString())),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
