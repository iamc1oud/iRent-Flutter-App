import 'package:flutter/material.dart';
import 'package:rent_app/style.dart';

class OwnerHomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const OwnerHomeScreen({Key key, this.userData}) : super(key: key);


  @override
  _OwnerHomeScreenState createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: AppStyle().headingBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: new Row(
                  children: <Widget>[
                    new CircleAvatar(
                      child: new Icon(Icons.people),
                    ),
                    new SizedBox(
                      width: 30,
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(widget.userData["firstname"]),
                      ],
                    )
                  ],
                )),
            preferredSize: Size.fromHeight(100)));
  }
}
