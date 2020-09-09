import 'package:flutter/material.dart';
import 'package:shareall/navigationPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
