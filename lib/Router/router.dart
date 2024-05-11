import 'package:fitness_tracking/Discover/fullbody.dart';
import 'package:flutter/material.dart';

class Router{
  Route<dynamic> createRoute (RouteSettings settings){
    switch(settings.name){
      case 'Discover/fullbody':
         return MaterialPageRoute(builder: (context) => const Fullbody());
    }
    
    throw Exception('No route found for ${settings.name}');

  }
  
}
