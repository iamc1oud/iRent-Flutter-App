import 'package:flutter/material.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Welcome to dashboard"),
      ),
    );
  }
}
