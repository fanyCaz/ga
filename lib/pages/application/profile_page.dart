import 'package:flutter/material.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int veces= 0;
  String usernameNow = "";
  String typeNow = "";
  String emailNow = "";
  void getUserNow() async {
    GAUser hola;
    var currentUser = await context.read<AuthenticationService>().getCurrentUser().then((value) => hola = value );
    setState(() {
      veces = 1;
      usernameNow = hola.username;
      emailNow = hola.email;
      typeNow = hola.type;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(veces == 0) {
      getUserNow();
    }
    return Scaffold(
      appBar: CommonAppBar(
        title: getTransValue(context, 'profile-title'),
        appBar: AppBar(),
        logout: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: IconButton(
            onPressed: (){
              context.read<AuthenticationService>().signOut();
              Navigator.pushNamed(context,home);
            },
            color: Colors.white,
            icon: Icon(Icons.logout),
          )
        ),
      ),
      drawer: DrawerList(),
      body: Padding(
        padding: EdgeInsets.only(top: kToolbarHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserImage(),
                SizedBox(height: 15,),
                Text(getTransValue(context, 'hello') + '${usernameNow} 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  )
                ,),
                Text(emailNow != null ? '${emailNow}' : "",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xffc4c4d5),
                    fontSize: 25,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, edit_profile);
                  },
                  child: Text(
                    getTransValue(context,'edit-profile') + "   >",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7B39ED),
                    side: BorderSide(color: Colors.white, width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))
                  ),
                ),
                SizedBox(height: 10,),
                Text( typeNow != "" ? getTransValue(context,typeNow) : "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffe6af3),
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Card(
                        color: Color(0xFFb79fdd),
                        shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('0',
                              style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                            Text(getTransValue(context,'number-photos'),
                              style: TextStyle(color: Color(0xFF846aaf), fontSize: 20,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]
            ),
          )
      ),
    );
  }


  Row UserImage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage : AssetImage(//hay que poner la imagen del perfil del usuario
              'lib/images/logo.png'),
          radius: 60,
        ),
      ]
    );
  }
}