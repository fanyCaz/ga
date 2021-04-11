import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/routes/route_names.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre nosotros'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('Hacia Sobre Nosotros', style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
              primary: Colors.blue
          ),
          onPressed: (){
            Navigator.pushNamed(context, internal_settings);
          },
        ),
      ),
    );
  }
}
