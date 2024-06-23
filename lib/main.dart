// import 'package:firebase_core/firebase_core.dart';
// import 'package:fitness_tracking/Forum/addForumPage.dart';
// import 'package:fitness_tracking/Forum/forumPage.dart';
// import 'package:fitness_tracking/Profile/auth_page.dart';
// import 'package:fitness_tracking/Profile/complete_profile.dart';
// import 'package:fitness_tracking/Profile/goal.dart';
// import 'package:fitness_tracking/Profile/profile.dart';
// import 'package:fitness_tracking/bottomNavigationBar.dart';
// import 'package:fitness_tracking/router.dart';
// import 'package:fitness_tracking/Forum/forumPage.dart';
// import 'package:fitness_tracking/Providers/timer_provider.dart';
// import 'package:fitness_tracking/Router/router.dart' as myRouter;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'Dashboard/home.dart';
// import 'Discover/discover.dart';
// import 'Forum/forumPage.dart';
// import 'Forum/detailsPage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {

//   final myRouter.Router _router = myRouter.Router();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<BottomNavigationBarProvider>( // Provide the BottomNavigationBarProvider here
//       create: (context) => BottomNavigationBarProvider(),
//       child: MaterialApp(
//         theme: ThemeData(
//           useMaterial3: true,
//         ),
//         home: AuthPage(),
//         onGenerateRoute: AppRouter().onGenerateRoute,
//       )
//     );   
//   }
// }

// class NavigationBarApp extends StatefulWidget {
//   @override
//   _NavigationBarAppState createState() => _NavigationBarAppState();
// }

// class _NavigationBarAppState extends State<NavigationBarApp> {
//   int _selectedIndex = 0;
//   final List<Widget> _pages = <Widget>[
//     HomePage(),
//     DiscoverPage(),
//     ForumPage(),
//     ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: _pages.asMap().entries.map((entry) {
//           final index = entry.key;
//           final page = entry.value;
//           return Offstage(
//             offstage: _selectedIndex != index,
//             child: TickerMode(
//               enabled: _selectedIndex == index,
//               child: page,
//             ),
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Discover',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.forum),
//             label: 'Forum',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Profile/auth_page.dart';
import 'package:fitness_tracking/Profile/complete_profile.dart';
import 'package:fitness_tracking/Profile/goal.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:fitness_tracking/Providers/timer_provider.dart';
import 'package:fitness_tracking/Router/router.dart' as myRouter;
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:fitness_tracking/Router/router.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:flutter/material.dart';
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
  final myRouter.AppRouter _router = myRouter.AppRouter();

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