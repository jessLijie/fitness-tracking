import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Profile/welcome_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  //sign user out method
  void signUserOut(BuildContext context) {
  FirebaseAuth.instance.signOut().then((_) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Replace this with the route name of your WelcomeScreen
      (route) => false, // Remove all routes until the new route
    );
  }).catchError((error) {
    print("Error signing out: $error");
    // Handle sign-out error if needed
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), actions: [
        IconButton(
          onPressed: () => signUserOut(context), 
          icon: Icon(Icons.logout),
          )
        ]
      ),
      body: Center(
        child: Text('Profile Page'),
        
      ),
    );
  }
}
