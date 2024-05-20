import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ForumRepo {
  final CollectionReference _postsColllection =
      FirebaseFirestore.instance.collection('forum');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final picker = ImagePicker();

//   Future<void> _uploadFile() async {
  
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     File file = File(pickedFile.path);
//     try {
//       String fileName = basename(file.path);
//       Reference storageRef = FirebaseStorage.instance.ref().child('forum_media/$fileName');
//       UploadTask uploadTask = storageRef.putFile(file);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       // Save downloadUrl to Firestore along with other post data
//     } catch (e) {
//       // Handle errors
//     }
//   }
// }
}
