import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/routes/route_names.dart';

const _duration = Duration(milliseconds: 500);

enum AnimationState{
  initial,
  start,
  end
}

class UploadAnimationInitial extends StatefulWidget {

  const UploadAnimationInitial({Key key, this.onAnimationStarted, this.progressAnimation}) : super(key: key);
  final VoidCallback onAnimationStarted;
  final Animation<double> progressAnimation;


  @override
  _UploadAnimationInitialState createState() => _UploadAnimationInitialState();
}

class _UploadAnimationInitialState extends State<UploadAnimationInitial> {

  AnimationState _currentState = AnimationState.start;
  Timer _timer;
  @override
  Widget build(BuildContext context) {
    widget.onAnimationStarted();
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(_currentState == AnimationState.end)
            Expanded(
              flex: 2,
              child: TweenAnimationBuilder(
                  tween: Tween(begin: 1.0,end: 1.0),
                  duration: _duration,
                builder: (_, value, child){
                  return Opacity(opacity: value, child: child);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(getTransValue(context, "loading-photo"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ProgressUpload(widget.progressAnimation),
                      )
                    ))
                  ],
                ),
              )
            ),
          if(_currentState != AnimationState.end)
            Expanded(
              flex: 2,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 1.0,end: _currentState != AnimationState.initial ? 0.0 :  1.0),
                duration: _duration,
                onEnd: (){
                  setState(() {
                    _currentState = AnimationState.end;
                  });
                  _timer = new Timer(const Duration(milliseconds: 4000), () {

                    Navigator.pop(context);
                    Navigator.pushNamed(context, principal);
                  });

                },
                builder: (_, value, child){
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(offset: Offset(0.0, -50 * value),child: child),
                  );
                },
                child: Column(
                  children: [
                    Text('Se está creando tu post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressUpload extends AnimatedWidget {
  ProgressUpload(Animation<double> animation): super(listenable: animation);

  double get value => (listenable as Animation).value;
  @override
  Widget build(BuildContext context) {
    print(value);
    return Text(
      '${(value*100).truncate().toString()} %',
    );
  }
}
