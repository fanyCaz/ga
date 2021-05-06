import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String image;
  final String description;
  final String uid;
  final int likes;
  final String username;
  final DateTime date;
  //EL id del Post es el id del documento en Firebase
  final String id;

  Post({this.image, this.description, this.uid, this.likes, this.username, this.date, this.id});

}