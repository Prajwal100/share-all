import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareall/pages/PostPage.dart';
import 'package:shareall/pages/comments.dart';
import 'package:shareall/utils/variables.dart';
import 'package:timeago/timeago.dart' as tAgo;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid;

  initState() {
    super.initState();
    getCurrentUserId();
  }

  getCurrentUserId() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseUser.uid;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShareAll'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Post(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream:
            postcollection.orderBy('posted_date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot postData = snapshot.data.documents[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(postData.data()['profile_pic']),
                    ),
                    title: Text(postData.data()['username']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tAgo
                            .format(postData.data()['posted_date'].toDate())),
                        if (postData.data()['type'] == 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(postData.data()['post']),
                          ),
                        if (postData.data()['type'] == 2)
                          Image(
                            image: NetworkImage(postData.data()['image']),
                          ),
                        if (postData.data()['type'] == 3)
                          Column(
                            children: [
                              Text(postData.data()['post'].toString()),
                              SizedBox(height: 20),
                              Image(
                                image: NetworkImage(postData.data()['image']),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => likePost(postData.data()['id']),
                                  child: FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    color:
                                        postData.data()['likes'].contains(uid)
                                            ? Colors.blue
                                            : Colors.black,
                                    size: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                    postData.data()['likes'].length.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => commentPost(
                                              postData.data()['id'])),
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
                                Text(postData.data()['comments'].toString()),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => sharePost(postData.data()['id'],
                                      postData.data()['post']),
                                  child: FaIcon(
                                    FontAwesomeIcons.shareAlt,
                                    size: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(postData.data()['shares'].toString()),
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
    );
  }
}
