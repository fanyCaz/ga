import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
              ElevatedButton(
                onPressed: () async {
                  if(_key.currentState.validate()){
                    try{
                      String result = await context.read<AuthenticationService>().signUp(
                          email: emailController.text.trim().toLowerCase(),
                          password: passwordController.text.trim()
                      );
                      if(result == "200"){
                        Navigator.pop(context);
                        Navigator.pushNamed(context,about);
                      }
                      if(result == "email-already-exists" || result == "email-already-in-use"){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(getTransValue(context, 'email-used'))))
                            .closed.then((value) => null);
                      }else if(result == "invalid-email"){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(getTransValue(context, 'invalid-email'))))
                            .closed.then((value) => null);
                      }else if(result == "invalid-password"){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(getTransValue(context, 'non-secure-password'))))
                            .closed.then((value) => null);
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(getTransValue(context, 'a-mistake'))))
                            .closed.then((value) => null);
                      }
                    } catch (e){
                      print(e);
                    }
                  }
                },
                child: Text( getTransValue(context,'btn_register') ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
