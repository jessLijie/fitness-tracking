import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracking/Profile/edit_profile.dart';
import 'package:fitness_tracking/services/auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userProfileFuture;
  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _getUserProfileData();
  }

  Future<Map<String, dynamic>> _getUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _db.collection('users').doc(user.uid).get();
      return snapshot.data() as Map<String, dynamic>;
    }
    return {}; // Return an empty map if user is not authenticated
  }

  Future<void> _registerAsTrainer() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({'role': 'trainer'});
      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered as Trainer')),
      );
      // Refresh the profile data to reflect the new role
      setState(() {
        _userProfileFuture = _getUserProfileData();
      });
    }
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
            onPressed: () => _authService.signOut(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _userProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Placeholder until data is fetched
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Error fetching user data')); // Error message if data retrieval fails
              }
              Map<String, dynamic> userData = snapshot.data!;
              
              return Column(
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
                        backgroundColor: Colors.grey,
                        child: userData['profileImageUrl'] != null
                            ? ClipOval(
                                child: Image.network(
                                  userData['profileImageUrl'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                      SizedBox(width: 20),
                      // Name and Edit Button
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              userData['full name'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              userData['goal'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Navigate to EditProfilePage and wait for the result
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(userData: userData),
                            ),
                          );
                          // Refresh the profile data
                          setState(() {
                            _userProfileFuture = _getUserProfileData();
                          });
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
                      ProfileBox(label: 'Height', value: '${userData['height']} m'),
                      ProfileBox(label: 'Weight', value: '${userData['weight']} kg'),
                      ProfileBox(label: 'BMI', value: '${userData['bmi']?.toStringAsFixed(2) ?? 'N/A'}'),
                      ProfileBox(label: 'Age', value: '${userData['age']} years old'),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Register as Trainer Button
                  ElevatedButton(
                    onPressed: _registerAsTrainer,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFC0FE87),
                    ),
                    child: Text('Register as Trainer'),
                  ),
                ],
              );
            },
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
        color: Color.fromARGB(255, 200, 230, 201),
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
