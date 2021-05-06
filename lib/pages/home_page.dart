import 'package:flutter/material.dart';
import 'package:gallery_array/classes/language.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/main.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:gallery_array/routes/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title:'Gallery Array',appBar: AppBar()),
      drawer: DrawerList(),
      body: _menuOptions(),
    );
  }

  Container _menuOptions(){
    final firebaseUser = context.watch<User>();
    if( firebaseUser != null){
      return upFeedPage();
    }
    return Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 20),
            child: Wrap(
              direction: Axis.vertical,
                spacing: 20,
                children:[
                  ElevatedButton(
                    onPressed:() {
                      Navigator.of(context).pushNamed(login);
                    },
                    child: Text(
                      getTransValue(context, 'btn_login'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width - 40,50),
                        primary: Color(0xFF7B39ED),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:() {
                      Navigator.of(context).pushNamed(register);
                    },
                    child: Text(
                      getTransValue(context, 'btn_register'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width - 40,50),
                      primary: Color(0xFF7B39ED),
                    ),
                  ),
                  Image.asset(
                    'lib/images/logo.png',fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ],
              ),
            ),
    );
  }
}
