import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return _drawerList(context,firebaseUser);
  }

  Container _drawerList(BuildContext context, User firebaseUser) {
    TextStyle _textStyle = TextStyle(
        color: Colors.white,
        fontSize: 24
    );
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.5,
      color: Theme
          .of(context)
          .primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              height: 100,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage : AssetImage(//hay que poner la imagen del perfil del usuario
                  'lib/images/logo.png'),
              ),
            ),
          ),
          firebaseUser != null ? ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
            title: Text(getTransValue(context,'logout-title'), style: _textStyle,),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthenticationService>().signOut();
              Navigator.pushNamed(context,home);
            },
          ) : SizedBox(height: 10,)
        ],
      ),
    );
  }
}