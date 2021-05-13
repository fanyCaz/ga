import 'package:flutter/material.dart';
import 'package:gallery_array/classes/call.dart';
import 'package:gallery_array/pages/application/CallPage.dart';
import 'package:gallery_array/pages/utils/AppID.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PickUpPage extends StatefulWidget {

  final Call call;

  PickUpPage({@required this.call});

  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await context.read<AuthenticationService>().endingCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    await Permission.camera.request();
                    await Permission.microphone.request();
                    var permissionCameraStatus = await Permission.camera.status;
                    var permissionMicrophoneStatus = await Permission.microphone.status;

                    if(permissionMicrophoneStatus.isGranted && permissionCameraStatus.isGranted){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              CallPage(call: widget.call))
                      );
                    }
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}