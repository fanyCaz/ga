import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:gallery_array/service/user_service.dart';
import 'package:provider/provider.dart';

class ChooseProfilePage extends StatefulWidget {

  @override
  _ChooseProfilePageState createState() => _ChooseProfilePageState();
}

class _ChooseProfilePageState extends State<ChooseProfilePage> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      appBar: CommonAppBar(title: getTransValue(context, 'choose_profile_title') ,appBar: AppBar(), canGoBack: false,),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 10, top: MediaQuery.of(context).size.height * .2),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1, bottom: 20),
                child: Row(
                  children: [
                      Text(
                        getTransValue(context, 'what_profile'),
                        style: TextStyle(color: Color(0xFF7B39ED), fontSize: 24 , fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              Row(
                children:[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed:() async {
                        await context.read<AuthenticationService>().finishRegister(
                            id: firebaseUser.uid, type: 'photographer',
                        );
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(principal);
                      },
                      icon: Icon(Icons.camera),
                      label: Text(
                        getTransValue(context, 'photographer'),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(MediaQuery.of(context).size.width * .4,100),
                        primary: Color(0xFF7B39ED),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:() async {
                      await context.read<AuthenticationService>().finishRegister(
                          id: firebaseUser.uid, type: 'painter'
                      );
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(principal);
                    },
                    icon: Icon(Icons.brush),
                    label: Text(
                      getTransValue(context, 'painter'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * .4,100),
                      primary: Color(0xFF7B39ED),
                    ),
                  ),
                ],
              ),
              TextButton(
                child: Text(getTransValue(context,'not-now'), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),),
                onPressed: () async {
                  await context.read<AuthenticationService>().finishRegister(
                      id: firebaseUser.uid, type: 'none'
                  );
                  Navigator.of(context).pushNamed(principal);
                },
              )
            ]
          ),
        ),
      )
    );
  }
}
