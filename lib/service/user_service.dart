import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_array/classes/ga_user.dart';

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

  Future<GAUser> usuarioActual(String uid)async{
    var response;
    await _firestore.collection("Users")
        .where('uid', isEqualTo: uid).limit(1).get().then((value) => value.docs.forEach((element) {print(element.id); response = element;}));
    return GAUser(uid: uid, type: response.data()['type'], username: response.data()['username'], email: response.data()['email'] );
  }

  Future<String> uploadPhotoPost({String uid, String image, String description, int likes}) async {
    String response = "200";
    try {
      await _firestore
          .collection("Post")
          .add(
          {
            'uid': uid,
            'image': image,
            'description': description,
            'likes': likes
          }
      ).then((value) => response = value.id).catchError((error) => print(error.toString()));
    }catch(Exception){
      return "500";
    }
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
}