import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rent_app/const.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                this.heading,
                style: Constants().headingTextStyle,
              ),
              new IconButton(
                onPressed: (){
                  print("Edit button clicked");
              }, icon: new Icon(Icons.edit, color: Colors.grey,),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: new Text(
                  this.data,
                  style: Constants().normalTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
