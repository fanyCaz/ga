import 'package:firebase_auth/firebase_auth.dart';
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

  List<Message> current_chats = new List<Message>();
  void getChats(String uid) async {
    Message msg;
    //context.read<AuthenticationService>().getChatsUser(uid);
    await context.read<AuthenticationService>()
        .haveChats()
        .then((value) => haveChats = value);
    current_chats = await context.read<AuthenticationService>().getChatsUser(uid);
    setState(() {
      print("Lenght chats");
      print(current_chats.length);
      _currentState = (haveChats) ? chatState.haveChats : chatState.doesntHaveChats;
      veces = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (veces == 0) {
      getChats(firebaseUser.uid);
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
      body:
      (_currentState == chatState.doesntHaveChats) ?
          Center( child: Text('No tienes chats'))
          : ListView.builder(itemBuilder: (context,i)
            {
              if(i < current_chats.length) {
                return _buildRow(current_chats[i]);
              }return SizedBox(height: 10,);
            }),
    );
  }

  Widget _buildRow(Message msg){
    return ListTile(
      title: Text(msg.idConversation),
      trailing: Icon(Icons.navigate_next),
      onTap: (){
        print("Holaa");
      },
    );
  }
}
