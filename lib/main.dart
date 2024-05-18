import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Profile/auth_page.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:fitness_tracking/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Dashboard/home.dart';
import 'Discover/discover.dart';
import 'Forum/forumPage.dart';
import 'Forum/detailsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationBarProvider>( // Provide the BottomNavigationBarProvider here
      create: (context) => BottomNavigationBarProvider(),
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
