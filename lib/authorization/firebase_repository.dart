import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_app/authorization/firebase_interface.dart';
import 'package:rent_app/style.dart';

class FirebaseRepository extends FirebaseHandlers {
  static FirebaseAuth firebaseAuth;
  static FirebaseUser currentUser;
  BuildContext context;

  FirebaseRepository() {
    firebaseAuth = FirebaseAuth.instance;
  }

  FirebaseAuth getFirebaseAuthInstance(){
      return firebaseAuth;
  }

  void setContext(BuildContext context){
    this.context = context;
  }

  @override
  Future<void> loginUser({String email, String password}) async {
    bool successfulLogin = false;

    /*`ERROR_INVALID_EMAIL` - If the email address is malformed.
    `ERROR_WRONG_PASSWORD` - If the password is wrong.
    `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given email address, or if the user has been deleted.
    `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.*/

    try {
      AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
       currentUser = authResult.user;
    }
    catch (e){
      switch(e.code){
        case "ERROR_INVALID_EMAIL":
          final SnackBar snackBar = SnackBar(content: Text("Invalid email"),);
          Scaffold.of(context).showSnackBar(snackBar);

          break;
        case "ERROR_WRONG_PASSWORD":
          final SnackBar snackBar = SnackBar(content: Text("Incorrect username or password"),
          );
          Scaffold.of(context).showSnackBar(snackBar);
          break;

        case "ERROR_USER_NOT_FOUND":
          print("Weak password");
          final SnackBar snackBar = SnackBar(content: Text("New user? Register first"),);
          Scaffold.of(context).showSnackBar(snackBar);

          break;
      }
    }

  }

  @override
  Future<void> registerUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    /*`ERROR_WEAK_PASSWORD` - If the password is not strong enough.
    `ERROR_INVALID_EMAIL` - If the email address is malformed.
    `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.*/

    try {
      final FirebaseUser user = (await firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      /* Update firebase database
      Fields stored:
      - Firstname
      - Lastname
      - Email

      If exisiting user tries to re-register, it will throw error, no
      new data will be updated to firebase
      */

      Firestore.instance.collection("user").document().setData({
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "uid": user.uid
      });

    } catch (e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          print("Weak password");
          final SnackBar snackBar = SnackBar(content: Text("Weak password"),);
          Scaffold.of(context).showSnackBar(snackBar);
          break;

        case "ERROR_INVALID_EMAIL":
          print("Invalid email");
          final SnackBar snackBar = SnackBar(content: Text("Invalid email"),);
          Scaffold.of(context).showSnackBar(snackBar);
          break;

        case "ERROR_EMAIL_ALREADY_IN_USE":
          print("Email already in use");
          final SnackBar snackBar = SnackBar(content: Text("Already registered"),);
          Scaffold.of(context).showSnackBar(snackBar);
          break;
      }
    }
  }
}
