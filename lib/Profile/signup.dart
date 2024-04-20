import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key});

  // Function to add user details to Firestore
  Future<void> addUserDetails(
    String fullName,
    String phoneNumber,
    String email,
    String height,
    String weight,
    int age,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'full name': fullName,
      'phone number': phoneNumber,
      'email': email,
      'height': height, // Add height field with default value
      'weight': weight, // Add weight field with default value
      'age': age,       // Add age field with default value
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    
    void showErrorMessage(String message){
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                message,
              )
            )
          );
        }
      );
    }

    Future<void> signUpWithEmailAndPassword(
      String fullName,
      String phoneNumber,
      String email,
      String password,
      String confirmPassword,
      String height,
      String weight,
      int age,
    ) async {
      showDialog(
        context: context, 
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
      try {
        // Check if password is confirmed password
        if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
          // Sign up user
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Add user details with default values for height, weight, and age
          await addUserDetails(
            fullNameController.text.trim(),
            phoneNumberController.text.trim(),
            emailController.text.trim(),
            'N/A', // Default height
            'N/A', // Default weight
            0,     // Default age
          );

          // Pop loading circle
          Navigator.pop(context);
        } else {
          // Pop loading circle
          Navigator.pop(context);
          // Show error message
          showErrorMessage("Passwords don't match");
          return;
        }
        // Pop loading circle
        Navigator.pop(context);
        // Navigate to the next screen or perform any other desired action
      } catch (e) {
        // Pop loading circle
        Navigator.pop(context);
        
        showErrorMessage('$e');
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF3FFE0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 90),
              Text(
                'Hey there',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Text(
                'Create an account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      signUpWithEmailAndPassword(
                        fullNameController.text,
                        phoneNumberController.text,
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        'N/A', // Default height
                        'N/A', // Default weight
                        0,     // Default age
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFC0FE87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
