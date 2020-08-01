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
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return placeholderWidget(context);
            break;
          case ConnectionState.done:
            data = snapshot.data.data;
            return Scaffold(
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: (){
                      print("Call person");
                    },
                    child: new Icon(Icons.call),
                  ),
                ),
                body:  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              data["firstname"],
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
                        galleryWidget(context, data["homeImagesUrl"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Text("Email Id",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "RobotoSlab")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: new Text(data["email"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "RobotoSlab")),
                        ),
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

  Widget placeholderWidget(BuildContext context){
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
                  fit: BoxFit.cover,
                  image: NetworkImage(urls[pos])
                )),
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
