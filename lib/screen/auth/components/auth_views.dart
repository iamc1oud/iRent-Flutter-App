import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/authorization/firebase_repository.dart';
import 'package:rent_app/screen/guest/guest_home.dart';
import 'package:rent_app/screen/guest/guest_info_register.dart';
import 'package:rent_app/screen/homescreen/home.dart';
import 'package:rent_app/screen/owner/owner_home.dart';
import 'package:rent_app/screen/owner/owner_info_register.dart';
import 'package:rent_app/style.dart';

class AuthViews extends StatefulWidget {
  final bool signup;

  const AuthViews({Key key, this.signup = false}) : super(key: key);

  @override
  _AuthViewsState createState() => _AuthViewsState();
}

class _AuthViewsState extends State<AuthViews> {
  FirebaseRepository firebaseRepository = new FirebaseRepository();

  // Login controllers
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  // Signup controllers
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordSignUpController = new TextEditingController();
  String _userStatus;

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(context) {
    return ListView(
      children: <Widget>[widget.signup ? signUpView(context) : loginView(context)],
    );
  }

  Widget loginView(BuildContext ctx) {
    firebaseRepository.setContext(ctx);

    // Controller for field username and password

    // Return Form widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 26.0, bottom: 8),
          child: new Text(
            "Welcome",
            style: TextStyle(
              fontSize: 30,
              color: AppStyle().secondaryTextColor,
              fontFamily: "RobotoSlab",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
          child: new TextFormField(
            controller: usernameController,
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
            controller: passwordController,
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    var user = await firebaseRepository.loginUser(
                        email: usernameController.text, password: passwordController.text);
                    if (user != null) {
                      // Find user in user collection
                      Stream<QuerySnapshot> identity =
                          firebaseRepository.findIdentityOfUser(email: usernameController.text);

                      identity.listen((event) {
                        print(event.documents[0].data);
                        if (event.documents[0].data["isOwnerOrGuest"] == "user_landlord") {
                          event.documents[0].data["isRegistered"] == false
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OwnerInfoRegisterScreen(
                                            userData: event.documents[0].data,
                                          )))
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OwnerHome(
                                            currentUserData: event.documents[0].data,
                                          )));
                        }
                        /*if (event.documents[0].data["isOwnerOrGuest"] == "user_landlord" && event.documents[0].data["isRegistered"] == true) {*/
                        else if(event.documents[0].data["isOwnerOrGuest"] == "user_guest") {
                          event.documents[0].data["isRegistered"] == false ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GuestInfoRegisterScreen(
                                    userData: event.documents[0].data,
                                  )))
                              : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GuestHomeScreen(
                                    currentUserData: event.documents[0].data,
                                  )));
                        }

                        /*else {
                          print("Function called");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GuestHomeScreen()));
                        }*/
                      });
                    } else {
                      print("Could not sign in");
                    }
                    // Navigate to homescreen
                    //Navigator.pushReplacementNamed(context, "/homescreen");
                  },
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
    );
  }

  Widget signUpView(BuildContext ctx) {
    firebaseRepository.setContext(ctx);

    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 26, bottom: 8),
            child: new Text(
              "Create account",
              style: TextStyle(fontFamily: "RobotoSlab", fontSize: 30, color: AppStyle().secondaryTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: new TextFormField(
              controller: firstNameController,
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
              controller: lastNameController,
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
              controller: emailController,
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
              controller: passwordSignUpController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ListTile(
                    title: const Text('Landlord'),
                    leading: Radio(
                      groupValue: _userStatus,
                      value: "user_landlord",
                      onChanged: (value) {
                        setState(() {
                          _userStatus = value;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ListTile(
                    title: const Text('Guest'),
                    leading: Radio(
                      groupValue: _userStatus,
                      value: "user_guest",
                      onChanged: (value) {
                        setState(() {
                          _userStatus = value;
                        });

                        print(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              child: new RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  var user = await firebaseRepository.registerUser(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordSignUpController.text,
                      isOwnerorGuest: _userStatus);

                  if (user != null && _userStatus == "user_landlord") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerInfoRegisterScreen()));
                  } else if (user != null && _userStatus == "user_guest") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GuestHomeScreen()));
                  }
                },
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
