import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_tracking/Profile/welcome_screen.dart';
import 'package:fitness_tracking/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({required this.userData, Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController fullNameController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController ageController;
  late String selectedGender;
  late String selectedGoal;
  File? _imageFile;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.userData['full name']);
    heightController = TextEditingController(text: widget.userData['height'].toString());
    weightController = TextEditingController(text: widget.userData['weight'].toString());
    ageController = TextEditingController(text: widget.userData['age'].toString());
    selectedGender = widget.userData['gender'] ?? '';
    selectedGoal = widget.userData['goal'] ?? '';
    _profileImageUrl = widget.userData['profileImageUrl'];
  }

  @override
  void dispose() {
    fullNameController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() => null);

      String imageUrl = await storageReference.getDownloadURL();
      setState(() {
        _profileImageUrl = imageUrl;
      });
    }
  }

  void saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Parse height and weight
      double height = double.tryParse(heightController.text) ?? 0.0;
      double weight = double.tryParse(weightController.text) ?? 0.0;

      // Calculate BMI
      double bmi = calculateBMI(height, weight);

      // Upload the profile image if there's one selected
      await uploadImage();

      // Update user profile
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'full name': fullNameController.text,
        'gender': selectedGender,
        'height': height,
        'weight': weight,
        'age': int.tryParse(ageController.text) ?? 0,
        'goal': selectedGoal,
        'bmi': bmi,
        'profileImageUrl': _profileImageUrl, // Update profile image URL
      });
      Navigator.pop(context);
    }
  }

  double calculateBMI(double height, double weight) {
    return weight / (height * height);
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Color.fromARGB(255, 200, 230, 201),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!) as ImageProvider
                          : AssetImage('assets/profile_image_placeholder.png'),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: fullNameController,
                decoration: _inputDecoration('Full Name'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: heightController,
                decoration: _inputDecoration('Height (m)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextField(
                controller: weightController,
                decoration: _inputDecoration('Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextField(
                controller: ageController,
                decoration: _inputDecoration('Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: _inputDecoration('Gender'),
                items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedGoal,
                onChanged: (value) {
                  setState(() {
                    selectedGoal = value!;
                  });
                },
                decoration: _inputDecoration('Goal'),
                items: ['Improve Shape', 'Maintain Weight', 'Lose Fat'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: saveProfile,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 200, 230, 201),
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text('Save'),
      ),
    ),
    SizedBox(width: 15),
    Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool confirmDelete = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Deletion'),
                content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );
          if (confirmDelete) {
            await AuthService().deleteAccount(context);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text('Delete Account'),
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
