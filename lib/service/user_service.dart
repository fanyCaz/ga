import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/classes/post.dart';
import 'package:gallery_array/service/utils.dart';

bool USE_FIRESTORE_EMULATOR = false;

class UserService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> create(GAUser user) async {
    String response = "error";
    try{
      await _firestore
          .collection("Users")
          .add(
        {
          'uid': user.uid,
          'lastname': user.lastname,
          'name' : user.name,
          'type' : user.type,
          'username':user.username,
          'email' : user.email
        }
      ).then((value) => response = value.id ).catchError((error) => print(error.toString()));

     // print( res.split('-')[1] );
      return "200";
    }catch(e){
      return e.toString();
    }
  }

  Future<String> typeOfArtist(String id, String type) async{
    String response = "error";
    try{
      var userHere = await _firestore.collection("Users")
          .where('uid', isEqualTo: id).limit(1).get().then((value) => value.docs.forEach((element) {print(element.id); response = element.id;}));
      await _firestore
          .collection("Users")
          .doc(response)
          .update(
          {
            'type' : type,
          }
      ).then((value) => print('si')).catchError((error) => print(error.toString()));
      return "200";
    }catch(e){
      return e.toString();
    }
  }

  Future<String> changeUsername({String username, String id, String name, String lastname}) async {
    String response = "error";
    try{
      var userHere = await _firestore.collection("Users")
          .where('uid', isEqualTo: id).limit(1).get().then((value) => value.docs.forEach((element) {print(element.id); response = element.id;}));
      if(username != "") {
        await _firestore
            .collection("Users")
            .doc(response)
            .update(
            {
              'username': username
            }
        ).then((value) => print('si')).catchError((error) =>
            print(error.toString()));
      }
      if(name != "") {
        await _firestore
            .collection("Users")
            .doc(response)
            .update(
            {
              'name': name
            }
        ).then((value) => print('si')).catchError((error) =>
            print(error.toString()));
      }
      if(lastname != "") {
        await _firestore
            .collection("Users")
            .doc(response)
            .update(
            {
              'lastname': lastname
            }
        ).then((value) => print('si')).catchError((error) =>
            print(error.toString()));
      }
      return "200";
    }catch(e){
      return e.toString();
    }
  }

  Future<GAUser> usuarioActual(String uid) async {
    var response;
    await _firestore.collection("Users")
        .where('uid', isEqualTo: uid).limit(1).get().then((value) => value.docs.forEach((element) {print(element.id); response = element;}));
    return GAUser(uid: uid, type: response.data()['type'], username: response.data()['username'], email: response.data()['email'] );
  }

  Future<String> uploadPhotoPost({String uid, String image, String description, int likes, String username, DateTime date}) async {
    String response = "200";
    try {
      await _firestore
          .collection("Post")
          .add(
          {
            'uid': uid,
            'image': image,
            'description': description,
            'likes': likes,
            'username': username,
            'date': date
          }
      ).then((value) => response = value.id).catchError((error) => print(error.toString()));
    }catch(Exception){
      return "500";
    }
  }

  Future<List<Post>> getFeed() async {
    List<Post> posts = new List<Post>();
    try {
      await _firestore.collection("Post")
          .get()
          .then((QuerySnapshot querysnap) {
        querysnap.docs.forEach((element) {
          Post pst = new Post(
              id: element.id,
              image: element["image"],
              description: element["description"],
              uid: element["uid"],
              likes: element["likes"],
              username: element["username"],
              date: element["date"].toDate()
          );
          if (pst != null) {
            posts.add(pst);
          }
        });
      });
    }catch(ex){
      print("Error en user service");
      print(ex);
    }
    return posts;
  }

  Future<List<String>> getPastLikedPosts(String uidUser) async {
    List<String> likedPosts = new List<String>();
    List<dynamic> likedTemp;
    try {
      await _firestore.collection("Users")
          .where('uid', isEqualTo: uidUser).limit(1).get().then(
              (value) =>
              value.docs.forEach(
                      (element) {
                    print(element.data());
                    print(element.data()["liked_posts"]);
                    likedTemp = element.data()["liked_posts"];
                  }
              )
      );
      print(likedTemp.runtimeType);
      for(int i = 0; i < likedTemp.length; i++){
        likedPosts.add(likedTemp[i]);
      }
      return likedPosts;
    }catch(exception){
      print("Error en get past liked posts");
      print(exception);
      return List<String>();
    }
  }

  Future<String> saveLikedPost(String idPost, String uidUser, bool add) async {
    String response = "error";
    List<dynamic> elements = new List<dynamic>();
    elements.add(idPost);
    await _firestore.collection("Post")
      .doc(idPost)
      .update({ 'likes' : FieldValue.increment(1) });
    await _firestore.collection("Users")
      .where('uid', isEqualTo: uidUser).limit(1).get()
        .then((value) => value.docs.forEach((element) {print(element.id); response = element.id;})
    );
    if(add) {
      await _firestore
          .collection("Users")
          .doc(response)
          .update(
          {
            'liked_posts': FieldValue.arrayUnion(elements)
          }
      ).then((value) => print('Agregado')).catchError((error) =>
          print(error.toString()));
    }else{
      await _firestore
          .collection("Users")
          .doc(response)
          .update(
          {
            'liked_posts': FieldValue.arrayRemove(elements)
          }
      ).then((value) => print('Removido')).catchError((error) =>
          print(error.toString()));
    }
    return "200";
  }

  Future<bool> haveChat(String uid) async {
    bool response = false;
    try {
      await _firestore.collection("Messages")
          .where('uidUser1', isEqualTo: uid).limit(1).get().then((value) =>
          value.docs.forEach((element) {
            print(element.id);
            response = element.exists;
          }));
      return response;
    }catch(Exception){
      return response;
    }
  }

  //Future<List<Message>>
  Future<List<Message>> getChats(String uid) async {
    List<Message> messagesChat = new List<Message>();
    await _firestore.collection("Messages")
        .get()
        .then((QuerySnapshot querysnap){
          querysnap.docs.forEach((element) {
            Message mss = new Message(
              uidUser1: element["uidUser1"], uidUser2: element["uidUser2"],
                id: element["id"], message: element["message"], date: element["date"]
            );
            if(mss != null) {messagesChat.add(mss);}
          });
        });
    return messagesChat;
  }
}