import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/components/custom_information_card.dart';
import 'package:rent_app/screen/auth/components/tab_bar.dart';

Widget profileWidget({String profileUrl, String firstname, String lastname}) {
  return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new CircleAvatar(maxRadius: 30, minRadius: 30, backgroundImage: NetworkImage(profileUrl)),
            ),
            new Text(
              firstname + " " + lastname,
              style: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          child: TabBarComponent(
            tabLength: 2,
            tabs: ["Personal", "Contact"],
            tabViews: <Widget>[
              tabBarPersonalWidget(),
              tabBarContactWidget(),
            ],
          ),
        ),
      ]));
}

Widget tabBarPersonalWidget() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        CustomInfoCard(
          heading: "Name",
          data: "Ajay Kumar Singh",
        ),
        CustomInfoCard(
          heading: "Address",
          data: "SMQ 101 D AFS Arjangarh",
        )
      ],
    ),
  );
}

Widget tabBarContactWidget() {
  String phoneNumber;
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        CustomInfoCard(
          heading: "Email",
          data: "ajay@gmail.com",
        ),
        CustomInfoCard(
          heading: "Phone Number",
          data: phoneNumber ?? "Not avaiable",
        )
      ],
    ),
  );
}
