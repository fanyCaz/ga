import 'package:flutter/material.dart';
import 'package:gallery_array/classes/language.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/main.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/route_names.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7B39ED),
        shadowColor: Colors.white,
        title: Text('GALLERY ARRAY', style: TextStyle( color: Colors.white) ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButton(
              onChanged: (Language language ){
                _changeLanguage(language);
              },
              underline: SizedBox(),
              icon: Icon(Icons.language, color: Colors.white),
              items: Language.languageList()
              .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                  value: lang,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ Text(lang.name), Text(lang.flag)],
                  )
                )
              ).toList(),
            ),
          )
        ],
      ),
      drawer: DrawerList(),
      body: _menuOptions(),
    );
  }

  Container _menuOptions(){
    return Container(
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
                spacing: 20,
                children:[
                  Image.asset(
                    'lib/images/logo.png',fit: BoxFit.cover,
                  ),
                  ElevatedButton(
                    onPressed:() {
                      Navigator.of(context).pushNamed(login);
                    },
                    child: Text(
                      getTransValue(context, 'btn_login'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200,50),
                        primary: Color(0xFF7B39ED),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:() {
                      Navigator.of(context).pushNamed(login);
                    },
                    child: Text(
                      getTransValue(context, 'btn_register'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200,50),
                        primary: Color(0xFF7B39ED),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
