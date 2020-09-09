import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:shareall/MainPage.dart';
import 'package:shareall/auth/LoginPage.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;

  // @override
  // void initState() {

  //   super.initState();
  //   Firebase.initializeApp();

  //   FirebaseAuth.instance.authStateChanges().listen((useraccount) {
  //     if (useraccount != null) {
  //       setState(() {
  //         isSigned = true;
  //       });
  //     } else {
  //       setState(() {
  //         isSigned = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? LoginPage() : MainPage(),
    );
  }
}
