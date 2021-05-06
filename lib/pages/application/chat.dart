import 'package:flutter/material.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/application/chat_header.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

enum chatState{
  haveChats,
  doesntHaveChats
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  chatState _currentState = chatState.doesntHaveChats;
  int veces = 0;
  bool haveChats = false;
  void getChats() async {
    Message msg;
    await context.read<AuthenticationService>()
        .haveChats()
        .then((value) => haveChats = value);
    setState(() {
      _currentState = (haveChats) ? chatState.haveChats : chatState.doesntHaveChats;
      print(haveChats);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (veces == 0) {
      getChats();
    }
    return Scaffold(
      appBar:CommonAppBar(
        title: getTransValue(context, 'chat'),
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
      body: Column(
        children: [
          (_currentState == chatState.doesntHaveChats) ?
              Center( child: Text('No tienes chats'))
              : Center( child: Text('si tienes')),
        ],
      ),
    );
  }
}
