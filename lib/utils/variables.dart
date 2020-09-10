import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

myStyles(double size, [Color color, FontWeight fw]) {
  return GoogleFonts.montserrat(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

CollectionReference usercollection =
    FirebaseFirestore.instance.collection('users');

CollectionReference postcollection =
    FirebaseFirestore.instance.collection('posts');

StorageReference postPictures =
    FirebaseStorage.instance.ref().child('post_pictures');

StorageReference profilePicture =
    FirebaseStorage.instance.ref().child('profile_picture');
