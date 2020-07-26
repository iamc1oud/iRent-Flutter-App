import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMapUserCard extends StatelessWidget {
  final String uid;

  const CustomMapUserCard({Key key, this.uid}) : super(key: key);

  // Use provider here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Text("Center"),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          print("Call");
        },
        label: Icon(Icons.call),
      ),
    );
  }
}
