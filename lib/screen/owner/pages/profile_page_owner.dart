import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/components/custom_information_card.dart';
import 'package:rent_app/const.dart';
import 'package:rent_app/providers/theme_provider.dart';

Widget profileWidget({String profileUrl, String firstname, String lastname}) {
  PageController _pageController = new PageController(viewportFraction: 0.98, );

  return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
          children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:18.0, right: 18),
              child: new CircleAvatar(
                  maxRadius: 30,
                  minRadius: 30,
                  backgroundImage: NetworkImage(profileUrl)),
            ),
            new Text(
              firstname + " " + lastname,
              style: Constants().headingTextStyle,
            ),
          ],
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: tabBarPersonalWidget()),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: tabBarContactWidget()),
              )
            ],
          ),
        ),
      ]));
}

Widget tabBarPersonalWidget() {
  return Padding(
    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18),
    child: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        new Text("Profile", style: Constants().extraLargeHeadingTextStyle,),
        new Divider(
          color: Colors.blue,
          thickness: 1.5,
        ),
        CustomInfoCard(
          heading: "Name",
          data: "IamCloud Dev",
        ),
        CustomInfoCard(
          heading: "Address",
          data: "SMQ 101 D AFS Arjangarh",
        ),
        CustomInfoCard(
          heading: "Bio",
          data: "Live Life For A Purpose ✨\nLearn something new everyday 📕\nLove to create 👨‍💻\nDeveloper 💯P.S. I also ❤ gaming.Other IG: @iamajju._",
        ),
      ],
    ),
  );
}

Widget tabBarContactWidget() {
  String phoneNumber;
  return Padding(
    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18),
    child: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        new Text("Contact", style: Constants().extraLargeHeadingTextStyle,),
        new Divider(
          color: Colors.blue,
          thickness: 1.5,
        ),
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
