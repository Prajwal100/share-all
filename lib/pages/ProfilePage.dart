import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareall/pages/comments.dart';
import 'package:shareall/utils/variables.dart';
import 'package:timeago/timeago.dart' as tAgo;

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
    getStream();
  }

  getStream() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      userStream =
          postcollection.where('uid', isEqualTo: firebaseUser.uid).snapshots();
    });
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

  @override
  Widget build(BuildContext context) {
    signOut() {
      FirebaseAuth.instance.signOut();
    }

    sharePost(String documentId, String post) async {
      Share.text("ShareAll", post, 'text/plan');
      DocumentSnapshot document = await postcollection.doc(documentId).get();

      postcollection.doc(documentId).update(
        {'shares': document.data()['shares'] + 1},
      );
    }

    likePost(String documentId) async {
      var firebaseuser = await FirebaseAuth.instance.currentUser;
      DocumentSnapshot document = await postcollection.doc(documentId).get();

      if (document.data()['likes'].contains(firebaseuser.uid)) {
        postcollection.doc(documentId).update({
          'likes': FieldValue.arrayRemove([firebaseuser.uid])
        });
      } else {
        postcollection.doc(documentId).update({
          'likes': FieldValue.arrayUnion([firebaseuser.uid])
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => signOut(),
            color: Colors.white,
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
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
                        Text(
                          'My Posts',
                        ),
                        StreamBuilder(
                          stream: userStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot postData =
                                    snapshot.data.documents[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            postData.data()['profile_pic']),
                                      ),
                                      title: Text(postData.data()['username']),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(tAgo.format(postData
                                              .data()['posted_date']
                                              .toDate())),
                                          if (postData.data()['type'] == 1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child:
                                                  Text(postData.data()['post']),
                                            ),
                                          if (postData.data()['type'] == 2)
                                            Image(
                                              image: NetworkImage(
                                                  postData.data()['image']),
                                            ),
                                          if (postData.data()['type'] == 3)
                                            Column(
                                              children: [
                                                Text(postData
                                                    .data()['post']
                                                    .toString()),
                                                SizedBox(height: 20),
                                                Image(
                                                  image: NetworkImage(
                                                      postData.data()['image']),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () => likePost(
                                                        postData.data()['id']),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.thumbsUp,
                                                      color: postData
                                                              .data()['likes']
                                                              .contains(uid)
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(postData
                                                      .data()['likes']
                                                      .length
                                                      .toString()),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                commentPost(
                                                                    postData.data()[
                                                                        'id'])),
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.comments,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(postData
                                                      .data()['comments']
                                                      .toString()),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () => sharePost(
                                                        postData.data()['id'],
                                                        postData
                                                            .data()['post']),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.shareAlt,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(postData
                                                      .data()['shares']
                                                      .toString()),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
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
