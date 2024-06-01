import 'package:fitness_tracking/Profile/goal.dart';
import 'package:fitness_tracking/Profile/welcome_screen.dart';
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:fitness_tracking/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Profile/complete_profile.dart';
import 'package:fitness_tracking/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  // Sign out method
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/', // Replace this with the route name of your WelcomeScreen
        (route) => false, // Remove all routes until the new route
      );
    } catch (e) {
      print("Error signing out: $e");
      // Handle sign-out error if needed
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String fullName,
    String phoneNumber,
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    // Check for empty fields
    if (fullName.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar(context, "Please fill out all the fields.");
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      _showSnackBar(context, "Passwords don't match");
      return;
    }

    // Check if password is at least 6 characters long
    if (password.length < 6) {
      _showSnackBar(context, "Password should be at least 6 characters");
      return;
    }

    // Check if phone number contains only numerical values
    if (!_isNumeric(phoneNumber)) {
      _showSnackBar(context, "Phone number should contain only numerical values");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await DatabaseService().addUserDetails(
        fullName.trim(),
        phoneNumber.trim(),
        email.trim(),
        uid,
      );

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteProfile(uid: uid),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar(context, '$e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  Future<void> updateUserProfile(
    String uid,
    String gender,
    String age,
    String weight,
    String height,
    String goalCal, 
    BuildContext context,
  ) async {
    DatabaseService().updateUserProfile(uid, gender, age, weight, height, goalCal);
    
    // Navigate to the GoalPage after updating profile
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalPage()),
    );
  }

  Future<void> updateGoal(String selectedGoal, BuildContext context) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update goal in Firestore
      await DatabaseService().updateGoal(user.uid, selectedGoal);
      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => bottomNavigationBarWidget(),
        ),
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent, check your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await DatabaseService().deleteUserData(user.uid); //delete from Firestore

        await user.delete(); //delete from Authentication

        await _auth.signOut(); //sign out

        // Navigate to the welcome page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()), // Replace WelcomeScreen with your welcome screen widget
          (route) => false, // Pop all routes until the new route is pushed
        );
      } catch (e) {
        print("Error deleting account: $e");
        // Handle errors as appropriate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
          ),
        );
      }
    } else {
      print("No user currently signed in. Not deleting account.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: No user currently signed in.'),
        ),
      );
    }
  }

  
  
  
}
