import 'package:flutter/material.dart';
import 'package:shareall/pages/HomePage.dart';
import 'package:shareall/pages/LoginPage.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? LoginPage() : HomePage(),
    );
  }
}
