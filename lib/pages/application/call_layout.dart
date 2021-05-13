import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/call.dart';
import 'package:gallery_array/pages/application/call_pickup.dart';
import 'package:gallery_array/pages/application/principal.dart';
import 'package:gallery_array/provider/user_provider.dart';
import 'package:gallery_array/service/user_service.dart';
import 'package:provider/provider.dart';

class CallLayoutPage extends StatefulWidget {
  @override
  _CallLayoutPageState createState() => _CallLayoutPageState();
}

class _CallLayoutPageState extends State<CallLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  //final CallMethods callMethods = CallMethods();
  final UserService us = UserService();
  PickupLayout({
    @required this.scaffold
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return (userProvider != null && userProvider.getUser != null) ?
      StreamBuilder<DocumentSnapshot>(
        stream: us.callStream(uid: userProvider.getUser.uid),
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data.data() != null){
            Call call = Call.fromMap(snapshot.data.data());
            return PickUpPage(call: call,);
          }//que retorne a la pagina principal mejor, eso de retornar el scaffold completo no me gusta
          return PrincipalPage();
        },
      ) : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
