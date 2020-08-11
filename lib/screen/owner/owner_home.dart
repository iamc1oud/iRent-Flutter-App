import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/providers/theme_provider.dart';
import 'package:rent_app/screen/map_renderer/nearby_map.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/screen/owner/pages/profile_page_owner.dart';
import 'package:rent_app/screen/owner/pages/settngs_page.dart';
import 'package:rent_app/style.dart';
import 'package:rent_app/utils/owner_firebase_operation.dart';

class OwnerHome extends StatefulWidget {
  final Map<String, dynamic> currentUserData;

  const OwnerHome({Key key, this.currentUserData}) : super(key: key);
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  PersistentTabController persistentTabController =
      new PersistentTabController();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return PersistentTabView(
      screens: _buildScreens(),
      items: _navBarsItems(provider),
      confineInSafeArea: true,
      backgroundColor: provider.isLightTheme ? Colors.white: AppStyle().darkColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 700),
          curve: Curves.easeIn),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 250),
      ),
      navBarStyle:
          NavBarStyle.style16, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    Position userPosition = new Position(
        latitude: widget.currentUserData["latitude"],
        longitude: widget.currentUserData["longitude"]);
    return [
      profileWidget(
          firstname: widget.currentUserData["firstname"],
          lastname: widget.currentUserData["lastname"],
          profileUrl: widget.currentUserData["profilePictureDownloadUrl"]),
      Container(
        color: Colors.indigoAccent,
        child: NearbyMapScreen(
          userPosition: userPosition,
        ),
      ),
      // Pass the current context to pop the Main Screen of app instead of popping only the current tab view.
      SettingWidget(ctx: context,)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(ThemeProvider provider) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Profile"),
        activeColor: provider.isLightTheme ? Colors.blue: Colors.white,
        inactiveColor: provider.isLightTheme ? Colors.grey: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.location_solid,
          color: provider.isLightTheme ? Colors.white : Colors.black,
        ),
        title: ("Nearby"),
        activeColor: provider.isLightTheme ? Colors.blue: Colors.white,
        inactiveColor: provider.isLightTheme ? Colors.grey: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColor: provider.isLightTheme ? Colors.blue: Colors.white,
        inactiveColor: provider.isLightTheme ? Colors.grey: Colors.grey,
      ),
    ];
  }
}
