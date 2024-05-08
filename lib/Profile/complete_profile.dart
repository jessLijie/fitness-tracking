import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController genderController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

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
                'Let\'s complete your profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: genderController,
                    decoration: InputDecoration(
                      hintText: 'Choose Gender',
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
                    controller: ageController,
                    decoration: InputDecoration(
                      hintText: 'Your Age',
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
                    controller: weightController,
                    decoration: InputDecoration(
                      hintText: 'Your Weight',
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
                    controller: heightController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Your Height',
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
                    controller: heightController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Goal',
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