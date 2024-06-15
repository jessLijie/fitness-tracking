import 'package:fitness_tracking/Discover/fullbodyOverview.dart';
import 'package:fitness_tracking/Discover/fullbodyWorkout.dart';
import 'package:fitness_tracking/data/model/fullbody.dart';
import 'package:fitness_tracking/Dashboard/home.dart';
import 'package:fitness_tracking/Discover/discover.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/Profile/signin.dart';
import 'package:fitness_tracking/Profile/signup.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/forumHome':
        return MaterialPageRoute(
          builder: (_) => ForumPage(),
        );
      case '/addForum':
        return MaterialPageRoute(
          builder: (_) => AddForumPage(),
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/Discover/discover':
        return MaterialPageRoute(
          builder: (_) => DiscoverPage(),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
      case '/signUp':
        return MaterialPageRoute(
          builder: (_) => SignUpPage(),
        );
      case '/signIn':
        return MaterialPageRoute(
          builder: (_) => SignInPage(),
        );
      case 'Discover/fullbodyOverview':
        return MaterialPageRoute(
          builder: (context) => const FullbodyOverview(),
        );
      case 'Discover/fullbodyWorkout':
        final Map<String, dynamic> args = routeSettings.arguments as Map<String, dynamic>;
        final List<Fullbody> workouts = args['workouts'] as List<Fullbody>;
        final int currentIndex = args['currentIndex'] as int;
        return MaterialPageRoute(
          builder: (context) => FullbodyWorkout(
            fullbodyWorkout: workouts,
            currentIndex: currentIndex,
          ),
        );
      default:
        return null;
    }
  }
}