import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/services/auth.dart';
import 'package:fitness_tracking/services/database.dart';

class Connection {
  final DatabaseService _databaseService = DatabaseService();

  Future<Map<String, dynamic>> getUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _databaseService.getUserProfileData(user.uid);
    }
    return {}; 
  }
}
