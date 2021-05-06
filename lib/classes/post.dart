import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String image;
  final String description;
  final String uid;
  final int likes;
  final String username;
  final DateTime date;

  Post({this.image, this.description, this.uid, this.likes, this.username, this.date});

}