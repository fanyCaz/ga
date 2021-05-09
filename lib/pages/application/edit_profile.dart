import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

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
          canGoBack: true,
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
        body: Padding(
          padding: EdgeInsets.all(2.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0,top: kToolbarHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text( getTransValue(context, 'edit-profile'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffe6af3),
                      fontSize: 30,
                    )
                  ),
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: getTransValue(context, 'name-controller'),
                    ),
                    controller: nameController,
                    validator: (value) {
                      return null;
                    }
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: getTransValue(context, 'lastname-controller'),
                      ),
                      controller: lastnameController,
                      validator: (value) {
                        return null;
                      }
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<AuthenticationService>().editUser(
                          username: usernameController.text.trim(), id: firebaseUser.uid,
                        name: nameController.text, lastname: lastnameController.text
                      );
                      Navigator.pop(context);
                      Navigator.pushNamed(context, profile_page);
                    },
                    child: Text(
                      getTransValue(context,'ready-edit-profile'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF7B39ED),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}