import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracking/Profile/signin.dart';
import 'package:fitness_tracking/Profile/signup.dart';
import 'package:flutter/material.dart';

import 'Dashboard/home.dart';
import 'Discover/discover.dart';
import 'Forum/forum.dart';
import 'Profile/profile.dart';
import 'Profile/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NavigationBarApp());
}

class NavigationBarApp extends StatefulWidget {
  @override
  _NavigationBarAppState createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    HomePage(),
    DiscoverPage(),
    ForumPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: _pages.asMap().entries.map((entry) {
            final index = entry.key;
            final page = entry.value;
            return Offstage(
              offstage: _selectedIndex != index,
              child: TickerMode(
                enabled: _selectedIndex == index,
                child: page,
              ),
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
