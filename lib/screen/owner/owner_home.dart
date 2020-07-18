import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/screen/owner/pages/profile_page_owner.dart';
import 'package:rent_app/utils/owner_firebase_operation.dart';

class OwnerHome extends StatefulWidget {
  final Map<String, dynamic> currentUserData;

  const OwnerHome({Key key, this.currentUserData}) : super(key: key);
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  PersistentTabController persistentTabController = new PersistentTabController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      screens: _buildScreens(),
      items: _navBarsItems(),

      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 300),
      ),
      navBarStyle: NavBarStyle.style16, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      profileWidget(
          firstname: widget.currentUserData["firstname"],
          lastname: widget.currentUserData["lastname"],
          profileUrl: widget.currentUserData["profilePictureDownloadUrl"]),
      Container(
        color: Colors.indigoAccent,
        child: MapBoxScreen(),
      ),
      Container(
        color: Colors.orangeAccent,
        child: Center(child: new Text("Settings")),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Profile"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.location_solid,
          color: Colors.white,
        ),
        title: ("Nearby"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }
}
