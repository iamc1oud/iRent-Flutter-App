import 'package:cached_network_image/cached_network_image.dart';
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
  static Map<String, dynamic> data;

  const CustomMapUserCard({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserDataProvider().getUserData(uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return placeholderWidget(context);
            break;
          case ConnectionState.done:
            data = snapshot.data.data;
            return Scaffold(
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          print("Call person");
                        },
                        child: new Icon(Icons.call),
                      ),
                    ),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(data["firstname"],
                                style: Constants().extraLargeHeadingTextStyle),
                            new CircleAvatar(
                              backgroundImage: NetworkImage(
                                  data["profilePictureDownloadUrl"]),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Text("Gallery",
                              style: Constants().headingTextStyle),
                        ),
                        galleryWidget(context, data["homeImagesUrl"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Text("Email Id",
                              style: Constants().headingTextStyle),
                        ),
                        new Text(data["email"],
                            style: Constants().normalTextStyle),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Text("Address",
                              style: Constants().headingTextStyle),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                                "SMQ 101 D, AFS Arjangarh, New Delhi - 110047",
                                style: Constants().normalTextStyle),
                          ],
                        ),
                      ],
                    )));
            break;
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
        }
        return SizedBox();
      },
    );
  }

  Widget placeholderWidget(BuildContext context) {
    return Material(
      child: Padding(
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
    );
  }

  Widget galleryWidget(BuildContext ctx, List<dynamic> urls) {
    return Container(
      height: MediaQuery.of(ctx).size.height * 0.5,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: urls.length,
          itemBuilder: (context, pos) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(urls[pos]))),
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
