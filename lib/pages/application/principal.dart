import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {

  final panelTransition = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final firebaseUser = context.watch<User>();
    if( firebaseUser == null){
      return HomePage();
    }

    return Scaffold(
      appBar: CommonAppBar(title: '',appBar: AppBar(), logout: Padding(
        padding: EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: (){
            context.read<AuthenticationService>().signOut();
            Navigator.pushNamed(context,home);
          },
          color: Colors.white,
          icon: Icon(Icons.logout),
        )
      )),
      drawer: DrawerList(),
      body: Container(
        child: Stack(
          children: [
            feed()
          ]
        ),
      )
    );
  }

  Column feed(){
    return Column(
      children: [
        Text('hlliii'),
      ],
    );
  }

  Row menu(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pushNamed(context, upload_photo);
          },
          child: Text(
            getTransValue(context, 'upload-photo'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7B39ED),
          ),
        )
      ],
    );
  }
}