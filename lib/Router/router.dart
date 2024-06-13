import 'package:fitness_tracking/Discover/fullbodyOverview.dart';
import 'package:fitness_tracking/Discover/fullbodyWorkout.dart';
import 'package:fitness_tracking/data/model/fullbody.dart';
import 'package:flutter/material.dart';

class Router{
  Route<dynamic> createRoute (RouteSettings settings){
    switch(settings.name){
      case 'Discover/fullbodyOverview':
         return MaterialPageRoute(builder: (context) => const FullbodyOverview());
      case 'Discover/fullbodyWorkout':
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final List<Fullbody> workouts = args['workouts'] as List<Fullbody>;
        final int currentIndex = args['currentIndex'] as int;
        return MaterialPageRoute(builder: (context) => FullbodyWorkout(fullbodyWorkout: workouts, currentIndex: currentIndex));
    }
    
    throw Exception('No route found for ${settings.name}');

  }
  
}
