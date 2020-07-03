import 'package:flutter/material.dart';
import 'package:rent_app/style.dart';

class AuthViews extends StatefulWidget {
  final bool signup;

  const AuthViews({Key key, this.signup = false}) : super(key: key);

  @override
  _AuthViewsState createState() => _AuthViewsState();
}

class _AuthViewsState extends State<AuthViews> {
  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(context) {
    return ListView(
      children: <Widget>[widget.signup ? signUpView() : loginView()],
    );
  }

  Widget loginView() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:26.0, bottom: 8),
            child: new Text(
              "Welcome",
              style:
                  TextStyle(fontSize: 30, color: AppStyle().secondaryTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  hintText: "someone@gmail.com",
                  labelText: "Email",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: "Password",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: new RaisedButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: () => print("Sign In User"),
                    child: new Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppStyle().secondaryTextColor,
                  ),
                ),
                new Text("Forgot password?"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpView() {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 26, bottom: 8),
            child: new Text(
              "Create account",
              style:
                  TextStyle(fontSize: 30, color: AppStyle().secondaryTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "First Name",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Last Name",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "someone@gmail.com",
                  labelText: "Email",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              cursorColor: Colors.deepOrange,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              child: new RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () => print("Sign In User"),
                child: new Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                color: AppStyle().secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
