import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/classes/post.dart';
import 'package:gallery_array/service/user_service.dart';

class AuthenticationService{
  //to firebase
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> confirmUploadPhoto(String uid, String image, String description, int likes, String username, DateTime date) async {
    UserService us = new UserService();
    try{
      await us.uploadPhotoPost(uid: uid, image: image, description: description, likes: likes, username: username, date: date);
      return "200";
    }catch(Exception){
      return "500";
    }
  }

  Future<String> editUser({String username, String id, String name, String lastname}) async {
    UserService us = new UserService();
    try{
      await us.changeUsername(username: username, id: id, name: name, lastname: lastname);
      return "200";
    }catch(e){
      return e.toString();
    }
  }

  Future<GAUser> getCurrentUser() async {
    UserService us = new UserService();
    return await _firebaseAuth.currentUser != null ? us.usuarioActual(_firebaseAuth.currentUser.uid) : null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "200";
    }on FirebaseAuthException catch (e){
      print(e.code);
      return e.code;
    } catch(e){
      return e.toString();
    }
  }

  Future<String> signUp({String email, String password, String username}) async{
    UserService us = new UserService();
    try{
      var createdUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await us.create(
          GAUser(uid: createdUser.user.uid, name: '', lastname: '', username: username, type: '', email: email )
      );
      return "200";
    } on FirebaseAuthException catch(e){
      return e.code;
    } catch(e){
      return e.toString();
    }
  }

  Future<String> finishRegister({String id, String type}) async {
    UserService us = new UserService();
    try{
      await us.typeOfArtist(id, type);
      return "200";
    }catch(e){
      return e.toString();
    }
  }

  Future<List<Post>> getImagesFeed() async {
    UserService us = new UserService();
    List<Post> posts = new List<Post>();
    try {
      posts = await us.getFeed();
      return posts;
    }catch(exception){
      print(exception);
      print("Hubo un error en el get images feed");
      return posts;
    }
  }

  Future<List<String>> pastLikedPosts(String uid) async {
    UserService us = new UserService();
    List<String> likedPosts = new List<String>();
    try {
      likedPosts = await us.getPastLikedPosts(uid);
      return likedPosts;
    }catch(exception){
      print(exception);
      print("Hubo un error en el  past liked posts");
      return likedPosts;
    }
  }

  Future<String> saveLikedPost(String idPost, String uidUser, bool add) async{
    UserService us = new UserService();
    try{
      await us.saveLikedPost(idPost, uidUser, add);
      return "200";
    }catch(exception){
      print("Hubo un error en save liked post de auth service");
      print(exception);
    }
    return "500";
  }

  Future<String> addConversation(String uid1, String uid2) async {
    UserService us = new UserService();
    try {
      String res = await us.makeConversation(uid1, uid2);
      return res;
    }catch(exception){
      print("Hubo un error en add conversation");
      print(exception);
    }
    return "500";
  }

  Future<void> sendMessage(String idConversation, String message) async {
    DateTime hoy = DateTime.now();
    UserService us = new UserService();
    us.sendMessage(idConversation, message, hoy);
  }

  Future<bool> haveChats({String uid}) async {
    UserService us = new UserService();
    bool response = false;
    try{
      response = await us.haveChat(uid);
      return response;
    }catch(e){
      return response;
    }
  }

  Future<List<Message>> getChatsUser(String  uid) async {
    UserService us = new UserService();
    List<Message> mesages = await us.getChats(uid);
    return mesages;
  }
}