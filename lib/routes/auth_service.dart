import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/service/user_service.dart';

class AuthenticationService{
  //to firebase
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  GAUser getCurrentUser(){
    return _firebaseAuth.currentUser != null ? GAUser(
        uid: _firebaseAuth.currentUser.uid,username: _firebaseAuth.currentUser.displayName
    ) : null;
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
          GAUser(uid: createdUser.user.uid, name: '', lastname: '', username: username, type: '' )
      );
      return "200";
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch(e){
      return e.toString();
    }
  }
}