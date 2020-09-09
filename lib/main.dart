import 'package:flutter/material.dart';
import 'package:shareall/navigationPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShareAll",
      debugShowCheckedModeBanner: false,
      home: NavigationPage(),
    );
  }
}
