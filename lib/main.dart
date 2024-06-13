import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Profile/auth_page.dart';
import 'package:fitness_tracking/Profile/complete_profile.dart';
import 'package:fitness_tracking/Profile/goal.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:fitness_tracking/Router/router.dart' as myRouter;
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:fitness_tracking/router.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Dashboard/home.dart';
import 'Discover/discover.dart';
import 'Forum/forumPage.dart';
import 'Forum/detailsPage.dart';

import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final myRouter.Router _router = myRouter.Router();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationBarProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: AuthPage(),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}
