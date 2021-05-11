import 'package:flutter/material.dart';
import 'package:gallery_array/pages/application/CallPage.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraExample extends StatefulWidget {
  @override
  _AgoraExampleState createState() => _AgoraExampleState();
}

class _AgoraExampleState extends State<AgoraExample> {

  final txtController = TextEditingController();
  bool _validateErr = false;
  //final PermissionHandler _permissionHandler = PermissionHandler();

  @override
  void dispose(){
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CommonAppBar(title: 'agora',appBar: AppBar()),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 100),),
            Image(
              image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.rover.com%2Fblog%2Fwp-content%2Fuploads%2F2018%2F12%2Fdog-sneeze-1-1024x945.jpg&f=1&nofb=1'),
              height: 100,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              'Agora demoooo',
              style: TextStyle(
                color: Colors.black, fontSize: 20,
                fontWeight: FontWeight.bold)
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),),
            Container(
              width: 300,
              child: TextFormField(
                controller: txtController,
                decoration: InputDecoration(
                  labelText: 'Channel',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Tesst',
                  hintStyle: TextStyle(color: Colors.black45),
                  errorText: _validateErr ? 'Channel is mandatory' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 30),),
            Container(
              width: 90,
              child: ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width - 40,50),
                  primary: Color(0xFF7B39ED),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Join', style: TextStyle(color: Colors.white),),
                    Icon(Icons.arrow_forward, color: Colors.white)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _validateErr = txtController.text.isEmpty;
    });
    await Permission.camera.request();
    await Permission.microphone.request();
    var permissionCameraStatus = await Permission.camera.status;
    var permissionMicrophoneStatus = await Permission.microphone.status;

    if(permissionMicrophoneStatus.isGranted && permissionCameraStatus.isGranted){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CallPage(channelName: txtController.text))
      );
    }
  }
}
