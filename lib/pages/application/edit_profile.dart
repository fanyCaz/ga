import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:gallery_array/service/user_service.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int veces = 0;
  String usernameNow = "";
  String typeNow = "";
  String emailNow = "hola@mail.com";

  void getUserNow() async {
    GAUser hola;
    var currentUser = await context.read<AuthenticationService>()
        .getCurrentUser()
        .then((value) => hola = value);
    setState(() {
      veces = 1;
      usernameNow = hola.username;
      emailNow = hola.email != null ? hola.email : "correo@mail";
      typeNow = hola.type;
      print(typeNow);
      print(usernameNow);
    });
  }

  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (veces == 0) {
      getUserNow();
    }
    return Scaffold(
        appBar: CommonAppBar(
          title: getTransValue(context, 'profile-title'),
          appBar: AppBar(),
          logout: Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.pushNamed(context, home);
                },
                color: Colors.white,
                icon: Icon(Icons.logout),
              )
          ),
        ),
        drawer: DrawerList(),
        body: Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: [
              Text("Edit Your Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30,
                )
              ),
              TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: getTransValue(context, 'username-controller'),
                  ),
                  controller: usernameController,
                  validator: (value) {
                    return null;
                  }
              ),
              ElevatedButton(
                onPressed: () async {
                  await context.read<AuthenticationService>().editUser(
                      username: '', id: firebaseUser.uid,
                  );
                  Navigator.pop(context);
                  Navigator.pushNamed(context, principal);
                },
                child: Text(
                  "Ready",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF7B39ED),
                ),
              )
            ],
          ),
        )
    );
  }
}