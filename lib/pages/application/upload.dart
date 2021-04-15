import 'package:flutter/material.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: getTransValue(context, 'upload-photo'),appBar: AppBar()),
        drawer: DrawerList(),
        body: Container(
        child: Column(
          children: [
            Text('Photo')
          ],
        ),
      ),
    );
  }
}
