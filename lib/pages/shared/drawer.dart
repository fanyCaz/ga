import 'package:flutter/material.dart';
import 'package:gallery_array/routes/route_names.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return _drawerList();
  }

  Container _drawerList() {
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
              child: CircleAvatar(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
            title: Text('About', style: _textStyle,),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, about);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            title: Text('Settings', style: _textStyle,),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, internal_settings);
            },
          )
        ],
      ),
    );
  }
}