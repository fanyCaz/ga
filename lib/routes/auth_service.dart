import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_array/classes/conversation.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/classes/post.dart';
import 'package:gallery_array/service/user_service.dart';
import 'package:gallery_array/classes/call.dart';

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
    GAUser user = new GAUser();
    user = await us.usuarioActual(_firebaseAuth.currentUser.uid);
    return user;
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

  Future<int> getNumberPhotos(String uid) async {
    UserService us = new UserService();
    try{
      return await us.countPhotoOfUser(uid);
    }catch(exception){
      print("Hubo error en get number photos");
      print(exception);
    }
    return 0;
  }

  Future<String> addConversation({String uid1, String uid2, String username1, String username2}) async {
    UserService us = new UserService();
    try {
      String res = await us.makeConversation(uid1, uid2, username1, username2);
      return res;
    }catch(exception){
      print("Hubo un error en add conversation");
      print(exception);
    }
    return "500";
  }

  Future<void> sendMessage(String idConversation, String message, String uidSender, String uidReceiver) async {
    DateTime hoy = DateTime.now();
    UserService us = new UserService();
    us.sendMessage(idConversation, message, hoy, uidSender, uidReceiver);
  }

  Future<List<Message>> getMessagesFromConversation(String idConversation) async {
    UserService us = new UserService();
    List<Message> messages = new List<Message>();
    try{
      messages = await us.getMessagesFeed(idConversation);
    }catch(exception){
      print("Error en get messages from conversation");
      print(exception);
    }
    return messages;
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

  Future<List<Conversation>> getChatsUser(String  uid) async {
    UserService us = new UserService();
    List<Conversation> conversations = new List<Conversation>();
    try {
      conversations = await us.getChats(uid);
      print("en get chats user conversations");
      print(conversations);
      return conversations;
    }catch(exception){
      print("Hubo error en get chatsuser auth service");
      print(exception);
    }
    return conversations;
  }

  Future<bool> endingCall({Call call}) async {
    UserService us = new UserService();
    try{
      bool callEnded = await us.endCall(call: call);
      return callEnded;
    }catch(exception){
      print("Error en ending call");
      print(exception);
    }
    return false;
    
  }
}