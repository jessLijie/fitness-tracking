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
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: "Inika",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture and Name with Edit Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    // Placeholder image or load the actual profile image
                    backgroundImage: AssetImage('assets/profile_image_placeholder.png'),
                  ),
                  SizedBox(width: 20),
                  // Name and Edit Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Lose a fat program',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle edit name button click
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 4 boxes
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ProfileBox(label: 'Height', value: '180 cm'),
                  ProfileBox(label: 'Weight', value: '75 kg'),
                  ProfileBox(label: 'BMI', value: '24.2'),
                  ProfileBox(label: 'Age', value: '30 years'),
                ],
              ),
              SizedBox(height: 20),
              // Register as Trainer Button
              ElevatedButton(
                onPressed: () {
                  // Handle register as trainer button click
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:  Color(0xFFC0FE87),
                ),
                child: Text('Register as Trainer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final String label;
  final String value;

  const ProfileBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 30,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Color.fromARGB(255, 200, 230, 201),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(value),
        ],
      ),
    );
  }
}
