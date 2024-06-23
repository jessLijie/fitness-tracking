import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier{
  int _seconds = 30;
  bool _isPaused = false; 
  Timer? _timer;

  // getters
  int get getSeconds => _seconds;
  
  void _startTimer(){
    // cancel any existing timer if there is any
    if(_timer != null && _timer!.isActive){
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1),  (timer){
      if(_seconds >0){
        _seconds--;
        notifyListeners();
      }else{
        _timer!.cancel();
      }
    });
  }

  // public api 
  void startTimer(){
    _startTimer();
    _isPaused = false;
    notifyListeners();
  }

  void pauseTimer(){
    if(_timer != null && _timer!.isActive){
      _timer!.cancel();
      _isPaused = true;
      notifyListeners();
    }
  }

  void resumeTimer(){
    if(_isPaused){
      _isPaused = false;
      _startTimer();
      notifyListeners();
    }
  }

  void resetTimer(){
    _timer!.cancel();
    _seconds = 30;
    notifyListeners();

  }

  void exitTimer(){
    _timer!.cancel();
    _seconds = 0;
    notifyListeners();
    dispose();
  }
}