import 'package:flutter/material.dart';
import 'package:gallery_array/pages/shared/upload_animation_initial.dart';

const mainBackupColor = Color(0xFF5113AA);
const secondaryBackupColor = Color(0xFFBC53FA);
const backgroundColor = Color(0xFFFCE7FE);

class uploadAnimationHome extends StatefulWidget {
  @override
  _uploadAnimationHomeState createState() => _uploadAnimationHomeState();
}

class _uploadAnimationHomeState extends State<uploadAnimationHome> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _progressAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 7));
    _progressAnimation = CurvedAnimation(parent: _animationController, curve: Interval(0.0, 0.65));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          UploadAnimationInitial(
            progressAnimation: _progressAnimation,
            onAnimationStarted: (){
              _animationController.forward();
            },
          ),
        ],
      ),
    );
  }
}