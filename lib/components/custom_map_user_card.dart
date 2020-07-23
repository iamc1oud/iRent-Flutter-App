import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMapUserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.black87,
          borderRadius: BorderRadius.circular(10)
        ),

        child: new Row(children: <Widget>[
          new Container(
            child: new Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: new Image(
                  image: AssetImage("assets/loading/loader.gif"), fit: BoxFit.cover, ),
              ),
              height: 70,
              width: 70,
            ),
          ),
          new SizedBox(width: 10,),
          new Text("Lee Cooper", style: TextStyle(fontSize: 30, color: Colors.white),),
          new SizedBox(width: 50,),
          Row(
            children: <Widget>[
              new Icon(CupertinoIcons.location, color: Colors.white, size: 30,),
              new Text("2.5 km", style: TextStyle(fontSize: 30, color: Colors.white)),
            ],
          )
        ],),
      ),
    );
  }
}
