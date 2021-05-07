import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_array/localization/constants.dart';
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

  final String uidUserReceiver;
  final String uidCurrentUser;

  const ChatConversationPage({Key key, this.uidUserReceiver, this.uidCurrentUser}) : super(key: key);

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {

  ChatConversationState _currentState = ChatConversationState.loading;
  String idConversation = "";
  List<Message> messages = new List<Message>();
  TextEditingController messageController = TextEditingController();

  void LoadConversation() async {
    idConversation = await context.read<AuthenticationService>().addConversation(widget.uidUser1, widget.uidUser2);
    print(idConversation);
    //messages
    setState(() {
      _currentState = ChatConversationState.hasMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(_currentState == ChatConversationState.loading){
      LoadConversation();
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
        //Agregar custom con nombre del usuario
      ),
      drawer: DrawerList(),
      body: (_currentState == ChatConversationState.loading) ?
        Center( child: CircularProgressIndicator() ) :
        Stack(
          children: [
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
                      Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].uidSender == firebaseUser.uid) ? 
                        Colors.blue[200] : Colors.grey.shade200,
                      ),
                      padding: EdgeInserts.all(16),
                      child: Text(
                        messages[index].message,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              }
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: getTransValue(context, 'send-conversation-message'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: (){},
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      elevation: 0,
                      onPressed: (){
                        context.read<AuthenticationService>()
                        .sendMessage(idConversation, messageController.text, widget.uidCurrentUser);
                      }
                    ),
                  ]
                ),
              ),
            ),
          ]
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Spacer(),
              Row(
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: getTransValue(context, 'send-conversation-message'),
                  ),
                  controller: messageController,
                  validator: (value) {
                    if(value.empty){
                      //do something
                      return null;
                    }
                    return null;
                  }
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: (){
                  _currentState = ChatConversationState.loading;
                  context.read<AuthenticationService>()
                  .sendMessage(idConversation, messageController.text, firebaseUser.uid);
                }
              ),
            ],
          ),
        ),
    );
  }
}
