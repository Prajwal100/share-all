import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shareall/utils/variables.dart';

class Post extends StatefulWidget {
  Post({Key key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File imagePath;
  bool uploading = false;
  TextEditingController postController = TextEditingController();
  pickImage(ImageSource imgsource) async {
    final image = await ImagePicker().getImage(source: imgsource);
    setState(() {
      imagePath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionsDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text('Choose from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text('From camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  uploadImage(String id) async {
    StorageUploadTask storageUploadTask =
        postPictures.child(id).putFile(imagePath);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  post() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    var allDocuments = await postcollection.get();
    int length = allDocuments.docs.length;

    // only text
    if (postController != '' && imagePath == null) {
      postcollection.doc('Post $length').set({
        'username': userdoc.data()['username'],
        'profile_pic': userdoc.data()['profile_pic'],
        'uid': firebaseuser.uid,
        'id': 'Post $length',
        'likes': [],
        'comments': 0,
        'shares': 0,
        'type': 1,
        'post': postController.text
      });
      Navigator.pop(context);
    }
    // only image
    if (postController == '' && imagePath != null) {
      String imageUrl = await uploadImage('Post $length');
      postcollection.doc('Post $length').set({
        'username': userdoc.data()['username'],
        'profile_pic': userdoc.data()['profile_pic'],
        'uid': firebaseuser.uid,
        'id': 'Post $length',
        'likes': [],
        'comments': 0,
        'shares': 0,
        'type': 2,
        'image': imageUrl,
      });
      Navigator.pop(context);
    }
    // both image & text
    if (postController != '' && imagePath != null) {
      String imageUrl = await uploadImage('Post $length');
      postcollection.doc('Post $length').set({
        'username': userdoc.data()['username'],
        'profile_pic': userdoc.data()['profile_pic'],
        'uid': firebaseuser.uid,
        'id': 'Post $length',
        'likes': [],
        'comments': 0,
        'shares': 0,
        'type': 3,
        'image': imageUrl,
        'post': postController.text
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: [
          IconButton(
            onPressed: () => optionsDialog(),
            icon: Icon(Icons.photo),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => post(),
        child: Icon(Icons.file_upload),
      ),
      body: uploading == false
          ? Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Expanded(
                    child: TextField(
                      controller: postController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Something on your mind....?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                imagePath == null
                    ? Container()
                    : MediaQuery.of(context).viewInsets.bottom > 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              height: 200,
                              width: double.infinity,
                              image: FileImage(imagePath),
                            ),
                          )
              ],
            )
          : Center(
              child: Text('Uploading....'),
            ),
    );
  }
}
