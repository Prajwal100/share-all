import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shareall/pages/PostPage.dart';
import 'package:shareall/utils/variables.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShareAll'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => signout(),
            icon: Icon(Icons.signal_cellular_off),
          ),
        ],
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
        stream: postcollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
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
                                FaIcon(
                                  FontAwesomeIcons.thumbsUp,
                                  size: 14,
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
                                FaIcon(
                                  FontAwesomeIcons.comments,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(postData.data()['comments'].toString()),
                              ],
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.shareAlt,
                                  size: 14,
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
