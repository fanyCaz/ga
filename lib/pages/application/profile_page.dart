import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int veces= 0;
  String usernameNow = "";
  String typeNow = "";
  void getUserNow() async {
    GAUser hola;
    var currentUser = await context.read<AuthenticationService>().getCurrentUser().then((value) => hola = value );
    setState(() {
      usernameNow = hola.username;
      print('seteado');
      veces = 1;
      typeNow = hola.type;
      print(hola.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(veces == 0) {
      getUserNow();
    }
    return Scaffold(
      appBar: CommonAppBar(title: getTransValue(context, 'profile-title'),appBar: AppBar()),
      drawer: DrawerList(),
      body: Container(
        child:  Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage : AssetImage(//hay que poner la imagen del perfil del usuario
                    'lib/images/logo.png'),
              ),
              Text('Perfil'),
              Text(usernameNow,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(typeNow,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
      ),
    );
  }

}
