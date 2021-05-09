import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/conversation.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/application/chat_conversation.dart';
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
    print("Get Chats dentro");
    print(currentConversations);
    setState(() {
      _currentState = (currentConversations.length > 0) ?
        chatState.haveChats : chatState.doesntHaveChats;
      veces = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print("En página chat");
    if(firebaseUser == null){
      return HomePage();
    }
    if (veces == 0) {
      print("Manda a llamar get chats");
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
            Text(getTransValue(context, 'no-chats'))
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
    print("ROWWW");
    print(cnv.id);
    print(cnv.usernameUser1);
    print(cnv.usernameUser2);
    print(uidCurrentUser);
    String userReceiver = "-";
    String userCurrent = "-";
    String uidReceiver = "-";
    String uidCurrent = "-";
    if(uidCurrentUser == cnv.userId1){
      userCurrent = cnv.usernameUser1;
      userReceiver = cnv.usernameUser2;
      uidCurrent = cnv.userId1;
      uidReceiver = cnv.userId2;
    }else{
      userCurrent = cnv.usernameUser2;
      userReceiver = cnv.usernameUser1;
      uidCurrent = cnv.userId2;
      uidReceiver = cnv.userId1;
    }
    return ListTile(
      dense: false,
      title: Text(" $userReceiver"),
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
                uidUser1: uidReceiver,
                uidUser2: uidCurrent,
                username1: userReceiver,
                username2: userCurrent,
              )
          )
        );
      },
    );
  }
}
