import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget profileWidget({String profileUrl, String firstname, String lastname}) {
  return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(children: <Widget>[
        new CircleAvatar(maxRadius: 60, minRadius: 30, backgroundImage: NetworkImage(profileUrl)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            firstname + " " + lastname,
            style: new TextStyle(fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Chip(
            label: new Text(
              "IN",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            avatar: new Icon(
              Icons.location_on,
              color: Colors.white,
            ),
          ),
        ),
      ]));
}
