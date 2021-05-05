import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 500);

enum AnimationState{
  initial,
  start,
  end
}

class UploadAnimationInitial extends StatefulWidget {
  @override
  _UploadAnimationInitialState createState() => _UploadAnimationInitialState();
}

class _UploadAnimationInitialState extends State<UploadAnimationInitial> {

  AnimationState _currentState = AnimationState.initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Text('Cloud',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
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
                  children: [
                    Text('uploading',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w300
                    ),)
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
          RaisedButton(
            child: Text('create'),
            onPressed: (){
              setState(() {
                _currentState = AnimationState.start;
              });
            },
          )
        ],
      ),
    );
  }
}
