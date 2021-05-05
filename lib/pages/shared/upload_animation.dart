import 'package:flutter/material.dart';
import 'package:gallery_array/pages/shared/upload_animation_initial.dart';

const mainBackupColor = Color(0xFF5113AA);
const secondaryBackupColor = Color(0xFFBC53FA);
const backgroundColor = Color(0xFFFCE7FE);

class uploadAnimationHome extends StatefulWidget {
  @override
  _uploadAnimationHomeState createState() => _uploadAnimationHomeState();
}

class _uploadAnimationHomeState extends State<uploadAnimationHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          UploadAnimationInitial(),
        ],
      ),
    );
  }
}