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

  final String uidUser1;
  final String uidUser2;

  const ChatConversationPage({Key key, this.uidUser1, this.uidUser2}) : super(key: key);

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {

  ChatConversationState _currentState = ChatConversationState.loading;
  String idConversation = "";
  TextEditingController messageController = TextEditingController();

  void LoadConversation() async {
    idConversation = await context.read<AuthenticationService>().addConversation(widget.uidUser1, widget.uidUser2);
    print(idConversation);
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
          )
        ),
      ),
      drawer: DrawerList(),
      body: (_currentState == ChatConversationState.loading) ?
        Center( child: CircularProgressIndicator() ) :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                Spacer(),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: getTransValue(context, 'send-conversation-message'),
                  ),
                  controller: messageController,
                  validator: (value) {
                    return null;
                  }
                ),
                IconButton(icon: Icon(Icons.send), onPressed: (){
                  context.read<AuthenticationService>().sendMessage(idConversation, messageController.text);
                })
              ],
            ),
        ),
    );
  }
}
