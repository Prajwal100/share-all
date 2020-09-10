import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:shareall/utils/variables.dart';
import 'package:image_picker/image_picker.dart';
// import '../models/user.dart';

// import 'home.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String profile_pic;
  bool isLoading = false;
  // User user;
  bool _passwordValid = true;
  bool _emailValid = true;
  bool _displayNameValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    var firebaseuser = await FirebaseAuth.instance.currentUser;

    DocumentSnapshot doc = await usercollection.doc(firebaseuser.uid).get();
    displayNameController.text = doc.data()['username'];
    emailController.text = doc.data()['email'];
    passwordController.text = doc.data()['password'];

    setState(() {
      isLoading = false;
      profile_pic = doc.data()['profile_pic'];
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: 'Update display name',
              errorText: _displayNameValid ? null : 'Display name too short'),
        )
      ],
    );
  }

  Column buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Email',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              hintText: 'Email Address',
              errorText: _emailValid ? null : 'Email address not valid'),
        )
      ],
    );
  }

  Column buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Password',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Password',
              errorText: _passwordValid
                  ? null
                  : 'Password must be at least 4 characher'),
        )
      ],
    );
  }

  File imagePath;
  pickImage(ImageSource imgsource) async {
    final image = await ImagePicker().getImage(source: imgsource);
    setState(() {
      imagePath = File(image.path);
    });
    // Navigator.pop(context);
  }

  uploadProfile(String id) async {
    StorageUploadTask storageUploadTask =
        profilePicture.child(id).putFile(imagePath);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  updateProfileData() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    String imageUrl = uploadProfile("Hello");

    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      emailController.text.contains('@') && emailController.text.isNotEmpty
          ? _emailValid = true
          : _emailValid = false;
      passwordController.text.trim().length < 4
          ? _passwordValid = false
          : _passwordValid = true;
    });

    if (_displayNameValid && _passwordValid && _emailValid) {
      usercollection.doc(firebaseuser.uid).update({
        'username': displayNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'profile_pic': imageUrl,
      });
    }
    // SnackBar snackbar = SnackBar(
    //   content: Text('Profile updated'),
    // );
    // _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8),
                        child: InkWell(
                          onTap: () => pickImage(ImageSource.gallery),
                          child: CircleAvatar(
                            backgroundImage: imagePath == null
                                ? NetworkImage(profile_pic)
                                : FileImage(imagePath),
                            radius: 50.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildEmailField(),
                            buildPasswordField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
