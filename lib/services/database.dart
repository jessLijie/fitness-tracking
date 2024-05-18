import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addUserDetails(
    String fullName,
    String phoneNumber,
    String email,
    String uid,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'full name': fullName,
      'phone number': phoneNumber,
      'email': email,
      'gender': '',  // Initialize with empty or default values
      'age': 0,
      'weight': 0.0,
      'height': 0.0,
      'bmi': 0.0,
      'goal': '',
    });
  }

  Future<void> updateUserProfile(
    String uid,
    String gender,
    String age,
    String weight,
    String height,
  ) async {
    // Validate inputs
    int parsedAge = int.tryParse(age) ?? 0;
    double parsedWeight = double.tryParse(weight) ?? 0;
    double parsedHeight = double.tryParse(height) ?? 0;

    // Calculate BMI
    double bmi = parsedWeight / (parsedHeight * parsedHeight);

    // Update user profile data in Firestore
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'gender': gender,
        'age': parsedAge,
        'weight': parsedWeight,
        'height': parsedHeight,
        'bmi': bmi,
      });
    } catch (error) {
      print("Error updating user profile: $error");
    }
  }

  Future<void> updateGoal(String uid, String selectedGoal) async {
    // Update the 'goal' field in Firestore document
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'goal': selectedGoal});
    } catch (error) {
      print("Error updating user goal: $error");
    }
  }

  Future<Map<String, dynamic>> getUserProfileData(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot.data() ?? {}; // Return an empty map if data is not available
  }

  Future<void> deleteUserData(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (error) {
      print("Error deleting user data: $error");
    }
  }
  
  
  
}

// Define options for gender dropdown
final Map<int, String> textMap = {
  0: 'Improve Shape',
  1: 'Maintain Weight',
  2: 'Lose Fat',
};

// Function to map index to image path
final Map<int, String> imageMap = {
  0: 'assets/image/gain.png',
  1: 'assets/image/maintain.png',
  2: 'assets/image/lose.png',
};
