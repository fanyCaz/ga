import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/service/user_service.dart';

class UserProvider with ChangeNotifier{
  UserService us = new UserService();

  FirebaseAuth _firebaseAuth;

  GAUser _usuario ;
  GAUser get getUser => _usuario;
  //UserProvider(this._firebaseAuth);

  void refreshUser() async {
    String uid = _firebaseAuth.currentUser.uid;
    GAUser user = await us.usuarioActual(uid);
    _usuario = user;
    notifyListeners();
  }
}