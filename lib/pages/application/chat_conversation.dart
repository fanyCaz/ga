import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_array/classes/message.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/application/CallPage.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:gallery_array/pages/utils/AppID.dart';

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
  final String idConversation;

  const ChatConversationPage({Key key, this.uidUser1, this.uidUser2, this.username1, this.username2, this.idConversation}) : super(key: key);

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
    //idConversation = await context.read<AuthenticationService>()
    // .addConversation(uid1: widget.uidUser1, uid2: widget.uidUser2, username1: widget.username1, username2: widget.username2);
    idConversation = widget.idConversation;
    messages = await context.read<AuthenticationService>().getMessagesFromConversation(idConversation);
    await context.read<AuthenticationService>().deleteNotifs(idConversation, widget.uidUser1);
    await context.read<AuthenticationService>().deleteNotifs(idConversation, widget.uidUser2);
    messages.sort((a,b) => a.date.compareTo(b.date));
    hasMessages = messages.length > 0;
    //messages
    setState(() {
      _currentState = (hasMessages) ?
        ChatConversationState.hasMessages :
        ChatConversationState.doesntHaveMessages;
    });
  }

  @override
  void initState() {
    super.initState();
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
            Text(' ${widget.username2}', style: TextStyle(fontSize: 24)) :
            Text(" ${widget.username1}", style: TextStyle(fontSize: 24)),
        ),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
                    child: Align(
                      alignment: (messages[index].uidSender == widget.uidUser2) ?
                        Alignment.topRight : Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].uidSender == firebaseUser.uid ? Colors.grey.shade200 : Colors.blue[200]),
                        ),
                        child: (messages[index].message.contains("Videollamada:")) ?
                          InkWell(
                            child: Text(getTransValue(context,'join-video'), style: TextStyle(color: Colors.blueAccent),),
                            onTap: (){
                              print("Hasta video");
                              onJoin();
                            },
                          ) :
                          Text(messages[index].message),
                        padding: EdgeInsets.all(16),
                      ),
                    )
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
                      FloatingActionButton(
                        heroTag: 'send-videocall',
                        child: Icon(Icons.videocam, color: Colors.white, size: 18),
                        elevation: 0,
                        onPressed: (){
                          String receiver = widget.uidUser2;
                          if(firebaseUser.uid == widget.uidUser1){
                            receiver = widget.uidUser1;
                          }
                          sendAMessage(messageLink: "Videollamada: $channelName1", uidSender: firebaseUser.uid, uidReceiver: receiver);
                          /*sendAMessage(
                            uidSender: firebaseUser.uid,
                            messageLink: "Videollamada: $channelName1"
                          );*/
                          onJoin();
                        },
                      ),
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
                        heroTag: 'send-message',
                        child: Icon(Icons.send, color: Colors.white, size: 18),
                        elevation: 0,
                        onPressed: (){
                          String receiver = widget.uidUser2;
                          if(firebaseUser.uid == widget.uidUser1){
                            receiver = widget.uidUser1;
                          }
                          sendAMessage(uidSender: firebaseUser.uid, uidReceiver: receiver);
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

  Future<void> sendAMessage({String uidSender, String messageLink = "", String uidReceiver}) async {
    if(messageLink != ""){
      await context.read<AuthenticationService>()
        .sendMessage(idConversation, messageLink, uidSender, uidReceiver);
    }else {
      await context.read<AuthenticationService>()
          .sendMessage(idConversation, messageController.text, uidSender, uidReceiver);
    }
    setState(() {
      messageController.clear();
      _currentState = ChatConversationState.loading;
    });
  }

  Future<void> onJoin() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    var permissionCameraStatus = await Permission.camera.status;
    var permissionMicrophoneStatus = await Permission.microphone.status;

    if(permissionMicrophoneStatus.isGranted && permissionCameraStatus.isGranted){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(channelName: channelName1)));
    }
  }
}
