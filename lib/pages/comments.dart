import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shareall/utils/variables.dart';
import 'package:timeago/timeago.dart' as tAgo;

class commentPost extends StatefulWidget {
  final String documentId;
  commentPost(this.documentId);
  @override
  _commentPostState createState() => _commentPostState();
}

class _commentPostState extends State<commentPost> {
  var commentController = TextEditingController();

  addComment() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await usercollection.doc(firebaseuser.uid).get();

    postcollection.doc(widget.documentId).collection('comments').doc().set({
      'comment': commentController.text,
      'username': userDoc.data()['username'],
      'uid': userDoc.data()['uid'],
      'profile_pic': userDoc.data()['profile_pic'],
      'time': DateTime.now(),
    });
    DocumentSnapshot commentCount =
        await postcollection.doc(widget.documentId).get();
    postcollection.doc(widget.documentId).update({
      'comments': commentCount.data()['comments'] + 1,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: postcollection
                      .doc(widget.documentId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, int index) {
                          DocumentSnapshot commentDoc =
                              snapshot.data.documents[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                    commentDoc.data()['profile_pic'],
                                  ),
                                ),
                                title: Text(commentDoc.data()['username']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tAgo.format(
                                        commentDoc.data()['time'].toDate())),
                                    Text(commentDoc.data()['comment'])
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Write comment",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () => addComment(),
                  child: Text('Post'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
