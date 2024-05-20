import 'package:fitness_tracking/Dashboard/home.dart';
import 'package:fitness_tracking/Discover/discover.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/Profile/signin.dart';
import 'package:fitness_tracking/Profile/signup.dart';
import 'package:flutter/material.dart';

class AppRouter {
  int categoryindex = 0;
  Route? onGenerateRoute(RouteSettings routeSettings) {
    int categoryindex = 0;
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

      default:
        return null;
    }
  }
}
