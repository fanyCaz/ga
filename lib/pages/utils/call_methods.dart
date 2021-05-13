import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/call.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/pages/application/CallPage.dart';
import 'package:gallery_array/service/user_service.dart';

class CallUtils{
  static final UserService us = new UserService();

  static dial({String fromUid, String fromUsername, String toUid, String toUsername
    , context}) async{
    Call call = Call(
      callerId: fromUid,
      callerName: fromUsername,
      receiverId: toUid,
      receiverName: toUsername,
      channelId: Random().nextInt(10000).toString(),
    );

    bool callMade = await us.makeCall(call: call);

    call.hasDialled = true;

    if(callMade){
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CallPage(call: call,))
      );*/
    }
  }
}