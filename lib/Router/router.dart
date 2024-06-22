import 'package:fitness_tracking/Discover/dumbbellOverview.dart';
import 'package:fitness_tracking/Discover/dumbbellWorkout.dart';
import 'package:fitness_tracking/Discover/fullbodyOverview.dart';
import 'package:fitness_tracking/Discover/fullbodyWorkout.dart';
import 'package:fitness_tracking/Discover/lowerbodyOverview.dart';
import 'package:fitness_tracking/Discover/lowerbodyWorkout.dart';
import 'package:fitness_tracking/data/model/dumbbell.dart';
import 'package:fitness_tracking/data/model/fullbody.dart';
import 'package:fitness_tracking/Dashboard/home.dart';
import 'package:fitness_tracking/Discover/discover.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/Profile/signin.dart';
import 'package:fitness_tracking/Profile/signup.dart';
import 'package:fitness_tracking/data/model/lowerbody.dart';
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
      case '/discover':
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
      case '/fullbodyOverview':
        return MaterialPageRoute(
          builder: (context) => FullbodyOverview(),
        );
      case '/fullbodyWorkout':
        final Map<String, dynamic> args = routeSettings.arguments as Map<String, dynamic>;
        final List<Fullbody> workouts = args['workouts'] as List<Fullbody>;
        final int currentIndex = args['currentIndex'] as int;
        return MaterialPageRoute(
          builder: (context) => FullbodyWorkout(
            fullbodyWorkout: workouts,
            currentIndex: currentIndex,
          ),
        );
      case '/dumbbellOverview':
        return MaterialPageRoute(
          builder: (context) => const DumbbellOverview(),
        );
      case '/dumbbellWorkout':
        final Map<String, dynamic> args = routeSettings.arguments as Map<String, dynamic>;
        final List<Dumbbell> workouts = args['workouts'] as List<Dumbbell>;
        final int currentIndex = args['currentIndex'] as int;
        return MaterialPageRoute(
          builder: (context) => DumbbellWorkout(
            dumbbellWorkout: workouts,
            currentIndex: currentIndex,
          ),
        );
      case '/lowerbodyOverview':
        return MaterialPageRoute(
          builder: (context) => const LowerbodyOverview(),
        );
      case '/lowerbodyWorkout':
        final Map<String, dynamic> args = routeSettings.arguments as Map<String, dynamic>;
        final List<Lowerbody> workouts = args['workouts'] as List<Lowerbody>;
        final int currentIndex = args['currentIndex'] as int;
        return MaterialPageRoute(
          builder: (context) => LowerbodyWorkout(
            lowerbodyWorkout: workouts,
            currentIndex: currentIndex,
          ),
        );
      default:
        return null;
    }
  }
}