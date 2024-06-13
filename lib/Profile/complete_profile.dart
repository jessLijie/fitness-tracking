import 'package:fitness_tracking/services/auth.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatefulWidget {
  final String uid;
  CompleteProfile({Key? key, required this.uid}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  String selectedGender = 'Male'; // Default selected gender

  final TextEditingController ageController = TextEditingController();
  final TextEditingController goalCalController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  // Define options for gender dropdown
  final List<String> genderOptions = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
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
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        // Update the selected gender
                        setState(() {
                          selectedGender = newValue;
                        });
                      }
                    },
                    items: genderOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                      prefixIcon:
                          Icon(Icons.calendar_month, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                    keyboardType:
                        TextInputType.number, // Allow only numeric input
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(
                      hintText: 'Your Weight(kg)',
                      prefixIcon: Icon(Icons.line_weight, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Allow numeric input with decimals
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: heightController,
                    decoration: InputDecoration(
                      hintText: 'Your Height(m)',
                      prefixIcon: Icon(Icons.height, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Allow numeric input with decimals
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: goalCalController,
                    decoration: InputDecoration(
                      hintText: 'Your goal calories (k) to be burnt per day',
                      prefixIcon: Icon(Icons.local_fire_department, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Color(0xFFF7F8F8),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number, // Allow numeric input with decimals
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Update user profile in Firestore and navigate to the next page
                      AuthService().updateUserProfile(
                        widget.uid,
                        selectedGender,
                        ageController.text,
                        weightController.text,
                        heightController.text,
                        goalCalController.text,
                       context,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      child: Text(
                        'Next',
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
