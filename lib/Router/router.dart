import 'package:fitness_tracking/Discover/fullbodyOverview.dart';
import 'package:fitness_tracking/Discover/fullbodyWorkout.dart';
import 'package:flutter/material.dart';

class Router{
  Route<dynamic> createRoute (RouteSettings settings){
    switch(settings.name){
      case 'Discover/fullbodyOverview':
         return MaterialPageRoute(builder: (context) => const FullbodyOverview());
      case 'Discover/fullbodyWorkout':
         return MaterialPageRoute(builder: (context) => const FullbodyWorkout());
    }
    
    throw Exception('No route found for ${settings.name}');

  }
  
}
