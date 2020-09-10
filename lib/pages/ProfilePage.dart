import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareall/pages/comments.dart';
import 'package:shareall/pages/editProfile.dart';
import 'package:shareall/pages/myPosts.dart';
import 'package:shareall/utils/variables.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid;
  String username;
  String profilePic;
  String coverPic;
  bool dataLoading = false;
  Stream userStream;

  @override
  initState() {
    super.initState();
    getCurrentUserId();
    getCurrentUserInfo();
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  getCurrentUserId() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseUser.uid;
    });
  }

  getCurrentUserInfo() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await usercollection.doc(firebaseuser.uid).get();

    setState(() {
      username = userDoc.data()['username'];
      profilePic = userDoc.data()['profile_pic'];
      coverPic = userDoc.data()['cover_pic'];
      dataLoading = true;
    });
  }

  Dialogue() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.edit),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => myPosts(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.edit),
                    Text('My Posts'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => signOut(),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.signOutAlt),
                    Text('LogOut'),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    signOut() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Dialogue(),
            color: Colors.white,
            icon: FaIcon(FontAwesomeIcons.ellipsisV),
          ),
        ],
      ),
      body: dataLoading == true
          ? SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image(
                        image: NetworkImage(
                          coverPic,
                        ),
                        fit: BoxFit.cover),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 6,
                        left: MediaQuery.of(context).size.width / 2 - 64),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(80))),
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(profilePic),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.9),
                    child: Column(
                      children: [
                        Text(
                          username,
                          style: myStyles(25, Colors.black54, FontWeight.bold),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Followers'.toUpperCase(),
                                      style: myStyles(
                                          16, Colors.grey, FontWeight.w500),
                                    ),
                                    Text(
                                      '10',
                                      style: myStyles(
                                          20, Colors.black45, FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Following'.toUpperCase(),
                                      style: myStyles(
                                          16, Colors.grey, FontWeight.w500),
                                    ),
                                    Text(
                                      '10',
                                      style: myStyles(
                                          20, Colors.black45, FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Posts'.toUpperCase(),
                                      style: myStyles(
                                          16, Colors.grey, FontWeight.w500),
                                    ),
                                    Text(
                                      '10',
                                      style: myStyles(
                                          20, Colors.black45, FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myPosts(),
                                ));
                          },
                          child: ListTile(
                            title: Text('Edit Profile'),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
