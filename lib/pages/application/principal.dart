import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    GAUser currentUser = context.read<AuthenticationService>().getCurrentUser();
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
        child: Column(
          children: [
            Spacer(),
            menu(),
          ]
        ),
      )
    );
  }

  Row menu(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        ElevatedButton(
          onPressed: (){},
          child: Text(
            'uno',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(

            primary: Color(0xFF7B39ED),
          ),
        ),
        ElevatedButton(
          onPressed: (){},
          child: Text(
            'dos',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(

            primary: Color(0xFF7B39ED),
          ),
        ),
        ElevatedButton(
          onPressed: (){

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