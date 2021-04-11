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
          'username':user.username
        }
      ).then((value) => print( "good ${value}")).catchError((error) => print(error.toString()));
      return response;
    }catch(e){
      return e.toString();
    }
  }
}