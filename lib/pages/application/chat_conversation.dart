import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_array/classes/conversation.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:provider/provider.dart';

enum ChatConversationState{
  loading,
  hasMessages,
  doesntHaveMessages
}

class ChatConversationPage extends StatefulWidget {

  final String uidUser1;
  final String uidUser2;
  final String username1;
  final String username2;

  const ChatConversationPage({Key key, this.uidUser1, this.uidUser2, this.username1, this.username2, }) : super(key: key);

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {

  ChatConversationState _currentState = ChatConversationState.loading;
  String idConversation = "";
  List<Message> messages = new List<Message>();
  TextEditingController messageController = TextEditingController();
  bool hasMessages = false;

  void loadConversation() async {
    print("ESTAMOS EN CHAT CONVERSATION");
    idConversation = await context.read<AuthenticationService>().addConversation(uid1: widget.uidUser1, uid2: widget.uidUser2, username1: widget.username1, username2: widget.username2);
    messages = await context.read<AuthenticationService>().getMessagesFromConversation(idConversation);
    messages.sort((a,b) => a.date.compareTo(b.date));
    hasMessages = messages.length > 0;
    //messages
    print(widget.username1);
    setState(() {
      _currentState = (hasMessages) ?
        ChatConversationState.hasMessages :
        ChatConversationState.doesntHaveMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser == null){
      return HomePage();
    }
    if(_currentState == ChatConversationState.loading){
      loadConversation();
    }
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        appBar: AppBar(),
        logout: Padding(
        padding: EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: (){
              context.read<AuthenticationService>().signOut();
              Navigator.pushNamed(context,home);
            },
            color: Colors.white,
            icon: Icon(Icons.logout),
          ),
        ),
        custom: Padding(
          padding: EdgeInsets.all(8.0),
          child: (_currentState == ChatConversationState.loading) ?
            Text('-') :
          (firebaseUser.uid == widget.uidUser1) ?
            Text(' ${widget.username1}', style: TextStyle(fontSize: 24)) :
            Text(" ${widget.username2}", style: TextStyle(fontSize: 24)),
        ),
        //Agregar custom con nombre del usuario
      ),
      drawer: DrawerList(),
      body: (_currentState == ChatConversationState.loading) ?
        Center( child: CircularProgressIndicator() ) :
        Stack(
          children: [
            (_currentState == ChatConversationState.hasMessages) ?
            ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].uidSender == firebaseUser.uid) ?
                    Alignment.topLeft : Alignment.topRight ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].uidSender == firebaseUser.uid) ? 
                        Colors.blue[200] : Colors.grey.shade200,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].message,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              }
            ) : Center(child: Text(getTransValue(context, 'no-messages')),),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: getTransValue(context, 'send-conversation-message'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    FloatingActionButton(
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      elevation: 0,
                      onPressed: (){
                        context.read<AuthenticationService>()
                        .sendMessage(idConversation, messageController.text, firebaseUser.uid);
                        setState(() {
                          _currentState = ChatConversationState.loading;
                        });
                      }
                    ),
                  ]
                ),
              ),
            ),
          ]
        ),
    );
  }
}
