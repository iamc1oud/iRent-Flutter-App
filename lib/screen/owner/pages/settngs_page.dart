import 'package:flutter/material.dart';
import 'package:rent_app/authorization/firebase_repository.dart';
import 'package:rent_app/screen/auth/auth.dart';
import 'package:rent_app/screen/splash_screen.dart';

class SettingWidget extends StatelessWidget {
  @required
  final BuildContext ctx;

  SettingWidget({Key key, this.ctx}) : super(key: key);

  final FirebaseRepository repository = new FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return settingsWidget(this.ctx);
  }

  Widget settingsWidget(BuildContext ctx) {
    return Column(
      children: <Widget>[
        new RaisedButton(
          onPressed: () {
            repository.logOut().then((value) => Navigator.pushReplacement(
                ctx, MaterialPageRoute(builder: (ctx) => SplashScreen())));
            print("Log out");
          },
          child: new Text("Log out"),
        )
      ],
    );
  }
}
