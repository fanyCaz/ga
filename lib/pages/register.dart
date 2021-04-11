import 'package:flutter/material.dart';
import 'package:gallery_array/localization/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _mainForm(context),
    );
  }

  Form _mainForm(BuildContext context){
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: Text(
                  getTransValue(context, 'personal_information'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return getTransValue(context, 'required_value');
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'required field';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'required field';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              child: Text('Enviar', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue
              ),
              onPressed: (){
                if(_key.currentState.validate()){

                }
              },
            )
          ],
        ),
      ),
    );
  }
}
