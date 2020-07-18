import 'package:flutter/material.dart';
import 'package:rent_app/screen/auth/components/tab_bar.dart';
import 'package:rent_app/screen/auth/components/auth_views.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarComponent(
        tabLength: 2,
        tabs: ["LOG IN", "SIGN UP"],
        tabViews: <Widget>[AuthViews(), AuthViews(signup: true)],
      ),
    );
  }
}
