import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/conversation.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/application/chat_conversation.dart';
import 'package:gallery_array/pages/application/chat_header.dart';
import 'package:gallery_array/pages/home_page.dart';
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
    //await context.read<AuthenticationService>().getCurrentUser().then((value) => hola = value );
    currentConversations = await context.read<AuthenticationService>().getChatsUser(uid);

    setState(() {
      _currentState = (currentConversations != null) ? chatState.haveChats : chatState.doesntHaveChats;
      veces = 1;
    });
  }

  /*void getChats(String uid) async {
    print("ESTAMOS EN CHAT");
    await context.read<AuthenticationService>()
        .haveChats()
        .then((value) => haveChats = value);
    if(haveChats) {
      currentConversations =
        await context.read<AuthenticationService>().getChatsUser(uid);
      _currentState = chatState.haveChats;
    }else{
      _currentState = chatState.doesntHaveChats;
    }
    setState(() {
      print("Lenght chats");
      print(currentConversations.length);
      print("Tiene chats");
      print(haveChats);
      _currentState = (haveChats) ? chatState.haveChats : chatState.doesntHaveChats;
      veces = 1;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      return HomePage();
    }
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
                Navigator.pop(context);
                context.read<AuthenticationService>().signOut();
                Navigator.pushNamed(context, home);
              },
              color: Colors.white,
              icon: Icon(Icons.logout),
            )
        ),
      ),
      drawer: DrawerList(),
      body: (_currentState == chatState.loading) ? Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.all(20),
        child: (_currentState == chatState.doesntHaveChats) ?
        Column(
          children: [
            Text(getTransValue(context, 'no-posts'))
          ],
        ): ListView.builder(
          itemCount: currentConversations.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xffe3d5eb),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  _buildRow(currentConversations[index],firebaseUser.uid)
                ]
              ),
            );
          },
        ),
      )
    );
  }

  Widget _buildRow(Conversation cnv, String uidCurrentUser){
    return ListTile(
      dense: false,
      title: Text(cnv.whoImTalkingTo),
      trailing: Wrap(
        spacing: 12,
        children: [
          Icon(
            Icons.navigate_next,
            color:Colors.red,
          ),
        ]
      ),
      onTap: (){
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) =>
              ChatConversationPage(
                uidUserReceiver: cnv.userId1,
                uidCurrentUser: cnv.userId2,
                userChatting: cnv.whoImTalkingTo,
              )
          )
        );
      },
    );
  }
}
