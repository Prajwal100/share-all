import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shareall/auth/SignupPage.dart';
import 'package:shareall/utils/variables.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  login() {
    Firebase.initializeApp();
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text, password: passwordcontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ShareAll',
              style: myStyles(25, Colors.white, FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Login',
              style: myStyles(
                20,
                Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 64,
              width: 64,
              child: Image.asset('images/logo.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  hintText: "you@example.com",
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email Address",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: passwordcontroller,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.lock_open),
                  labelText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                login();
              },
              child: Text('Login'),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Don't have an account?"),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
