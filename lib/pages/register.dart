import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/choose_profile.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:gallery_array/service/user_service.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String error_message = '';

  void showError(error){
    String _temp = '';
    if(error == "email-already-exists" || error == "email-already-in-use"){
      _temp = getTransValue(context, 'email-used');
    }else if(error == "invalid-email"){
      _temp = getTransValue(context, 'invalid-email');
    }else if(error == "invalid-password"){
      _temp = getTransValue(context, 'non-secure-password');
    }else{
      _temp = getTransValue(context, 'a-mistake');
    }
    setState(() {
      error_message = _temp;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: getTransValue(context, 'back'),appBar: AppBar()),
      body: Container(
        child: _mainForm(context),
      ),
    );
  }

  Form _mainForm(BuildContext context){
    return Form(
      key: _key,
      child: Padding(
        padding: EdgeInsets.only(left: 15.0,right: 15.0),
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: getTransValue(context, 'username'),
                ),
                controller: usernameController,
                validator: (value){
                  if(value.isEmpty){
                    return getTransValue(context, 'non-empty-value');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: getTransValue(context, 'email'),
                ),
                controller: emailController,
                validator: (value){
                  if(value.isEmpty){
                    return getTransValue(context, 'non-empty-value');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: getTransValue(context, 'password'),
                  ),
                  controller: passwordController,
                  validator: (value){
                    password = value;
                    if(value.isEmpty){
                      return getTransValue(context, 'non-empty-value');
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 10,),
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: getTransValue(context, 'password-confirmation'),
                  ),
                  controller: passwordConfirmController,
                  validator: (value){
                    if(value.isEmpty){
                      return getTransValue(context, 'non-empty-value');
                    }else if(value != password ){
                      return  getTransValue(context, 'non-same-password');
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 10,),
              Text(error_message, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  if(_key.currentState.validate()){
                    try{
                      String result = await context.read<AuthenticationService>().signUp(
                          email: emailController.text.trim().toLowerCase(),
                          password: passwordController.text.trim(),
                        username: usernameController.text
                      );
                      print(result);
                      if(result == "200"){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, choose_profile);
                      } else{
                        showError(result);
                      }
                    } catch (e){
                      print(e);
                    }
                  }
                },
                child: Text( getTransValue(context,'btn_register') ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width,50),
                  primary: Color(0xFF7B39ED),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
