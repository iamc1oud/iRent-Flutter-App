import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rent_app/geolocator_api/geolocator_provider.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/screen/owner/pages/profile_page_owner.dart';
import 'package:rent_app/screen/owner/pages/settngs_page.dart';
import 'package:rent_app/utils/owner_firebase_operation.dart';

class GuestHomeScreen extends StatefulWidget {
  final Map<String, dynamic> currentUserData;

  const GuestHomeScreen({Key key, this.currentUserData}) : super(key: key);
  @override
  _GuestHomeScreenState createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  PersistentTabController persistentTabController =
      new PersistentTabController();
  GeolocatorProvider geolocatorProvider = new GeolocatorProvider();
  Position currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    getLocation();
    super.initState();
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });
    Position position = await geolocatorProvider.getCurrentLocationLatLng();
    setState(() {
      currentPosition = position;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xfff8f8ff),
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
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 300),
      ),
      navBarStyle:
          NavBarStyle.style16, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      profileWidget(
          firstname: widget.currentUserData["firstname"],
          lastname: widget.currentUserData["lastname"],
          profileUrl: widget.currentUserData["profilePictureDownloadUrl"] ??
              "https://static.toiimg.com/photo/72975551.cms"),
      isLoading ?  new CircularProgressIndicator(): Container(
        color: Colors.indigoAccent,
        child: MapBoxScreen(
          currentUserImageUrl:
              widget.currentUserData["profilePictureDownloadUrl"],
          userPosition: currentPosition,
        ),
      ),
      // Pass the current context to pop the Main Screen of app instead of popping only the current tab view.
      SettingWidget(
        ctx: context,
      )
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
