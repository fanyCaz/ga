import 'package:flutter/material.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String error_message = '';

    void showError(error){
      String _temp = '';
      if(error == "invalid-email"){
        _temp = getTransValue(context, 'invalid-email');
      }else if(error == "wrong-password"){
        _temp = getTransValue(context, 'invalid-password');
      }else{
        _temp = getTransValue(context, 'a-mistake');
      }
      setState(() {
        error_message = _temp;
      });
    }

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: CommonAppBar(title: getTransValue(context, 'back'),appBar: AppBar()),
          body: Container(
            child: _login(context),
          )
      );
    }

    Form _login(BuildContext context){
      return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 15.0,right: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Center(
                    child: Text(
                      getTransValue(context, 'login-title'),
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
                      if(value.isEmpty){
                        return getTransValue(context, 'non-empty-value');
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 10,),
                Text((error_message == null) ? '' : error_message, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      try {
                        String result = await context.read<
                            AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()
                        );
                        if (result == "200") {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, principal);
                        }else{
                          showError(result);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text( getTransValue(context, 'btn_login') ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width,50),
                    primary: Color(0xFF7B39ED),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
