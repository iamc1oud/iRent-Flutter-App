import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomInfoCard extends StatelessWidget {
  final String heading;
  final String data;

  const CustomInfoCard({
    @required this.data,
    @required this.heading,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            this.heading,
            style: TextStyle(fontFamily: "RobotoSlab", fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                this.data,
                style: TextStyle(fontFamily: "RobotoSlab", fontSize: 16),
              ),
              new CupertinoButton(child: new Icon(Icons.edit), onPressed: () {})
            ],
          ),
        ],
      ),
    );
  }
}
