import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/conversation.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/application/chat_header.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

enum chatState{
  loading,
  haveChats,
  doesntHaveChats
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  chatState _currentState = chatState.loading;
  int veces = 0;
  bool haveChats = false;

  List<Conversation> currentConversations = new List<Conversation>();
  void getChats(String uid) async {
    print("ESTAMOS EN CHAT");
    await context.read<AuthenticationService>()
        .haveChats()
        .then((value) => haveChats = value);
    currentConversations = await context.read<AuthenticationService>().getChatsUser(uid);
    setState(() {
      print("Lenght chats");
      print(currentConversations.length);
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
      (_currentState == chatState.loading) ?
      Center( child: CircularProgressIndicator() ) :
      (_currentState == chatState.doesntHaveChats) ?
        Center( child: Text('No tienes chats'))
        : ListView.builder(
          itemCount: currentConversations.length,
          itemBuilder: (context,i)
          {
            return _buildRow(currentConversations[i]);
          }),
    );
  }

  Widget _buildRow(Conversation cnv){
    print(cnv.id);
    print(cnv.userId1);
    print(cnv.userId2);
    return ListTile(
      title: Text(cnv.id),
      trailing: Icon(Icons.navigate_next),
      onTap: (){
        print("Holaa");
      },
    );
  }
}
