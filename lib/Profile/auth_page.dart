import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Dashboard/home.dart';
import 'package:fitness_tracking/Profile/signin.dart';
import 'package:fitness_tracking/Profile/welcome_screen.dart';
import 'package:fitness_tracking/main.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is logged in
          if (snapshot.hasData) {
            return NavigationBarApp();
          }

          //user is not logged in
          else {
            return WelcomeScreen();
          }
        },
      )
    );
  }
}