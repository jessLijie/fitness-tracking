// // // import 'dart:io';

// // // import 'package:flutter/material.dart';
// // // import 'package:image_picker/image_picker.dart';

// // // class AddForumPostPage extends StatefulWidget {
// // //   @override
// // //   _AddForumPostPageState createState() => _AddForumPostPageState();
// // // }

// // // class _AddForumPostPageState extends State<AddForumPostPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   String title = '';
// // //   String description = '';
// // //   File? imageFile;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Add Forum Post')),
// // //       body: Form(
// // //         key: _formKey,
// // //         child: Column(
// // //           children: [
// // //             TextFormField(
// // //               decoration: InputDecoration(labelText: 'Title'),
// // //               onSaved: (value) => title = value!,
// // //               validator: (value) =>
// // //                   value!.isEmpty ? 'Please enter a title' : null,
// // //             ),
// // //             TextFormField(
// // //               decoration: InputDecoration(labelText: 'Description'),
// // //               onSaved: (value) => description = value!,
// // //               validator: (value) =>
// // //                   value!.isEmpty ? 'Please enter a description' : null,
// // //             ),
// // //             // Add buttons for image/video upload
// // //             Row(
// // //               children: [
// // //                 TextButton(
// // //                   onPressed: () => _selectMedia(),
// // //                   child: Text('Upload Media'),
// // //                 ),
// // //                 TextButton(
// // //                   onPressed: () {
// // //                     if (_formKey.currentState!.validate()) {
// // //                       _formKey.currentState!.save();
// // //                       _uploadPost(context);
// // //                     }
// // //                   },
// // //                   child: Text('Submit Post'),
// // //                 )
// // //               ],
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //     // Use image_picker or similar package to select media
// // //     List<File> mediaFiles = [];

// // // Future<void> _selectMedia() async {
// // //   final ImagePicker _picker = ImagePicker();
// // //   final List<XFile>? selectedFiles = await _picker.pickMultipleMedia(); // For selecting multiple images

// // //   if (selectedFiles != null && selectedFiles.isNotEmpty) {
// // //     for (var file in selectedFiles) {
// // //       mediaFiles.add(File(file.path));
// // //     }
// // //   }

// // //   // To allow video selection as well
// // //   final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
// // //   if (video != null) {
// // //     mediaFiles.add(File(video.path));
// // //   }

// // //   setState(() {});
// // // }

// // //   void _uploadPost(BuildContext context) async {
// // //     // Upload media to Firebase Storage and then save post data to Firestore
// // //   }

// // // }
// // import 'dart:io';
// // import 'package:fitness_tracking/bottomNavigationBar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:path/path.dart' as path;

// // class AddForumPostPage extends StatefulWidget {
// //   @override
// //   _AddForumPostPageState createState() => _AddForumPostPageState();
// // }

// // class _AddForumPostPageState extends State<AddForumPostPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   List<File> mediaFiles = [];
// //   final ImagePicker _picker = ImagePicker();
// //   String title = '';
// //   String description = '';

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //bottomNavigationBar: NavigationBarApp(),
// //       backgroundColor: Color.fromRGBO(239, 255, 224, 1),
// //       appBar: AppBar(
// //         title: Text(
// //           "Add Forum",
// //           style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Color.fromRGBO(239, 255, 224, 1),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: <Widget>[
// //               TextFormField(
// //                 decoration: InputDecoration(labelText: 'Title'),
// //                 onSaved: (value) => title = value!,
// //                 validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
// //               ),
// //               TextFormField(
// //                 decoration: InputDecoration(labelText: 'Description'),
// //                 onSaved: (value) => description = value!,
// //                 validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
// //               ),
// //               ElevatedButton(
// //                 onPressed: _selectMedia,
// //                 child: Text('Upload Media'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: _uploadPost,
// //                 child: Text('Submit Post'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _selectMedia() async {
// //     final XFile? selectedImages = await _picker.pickImage(source: ImageSource.gallery);

// //     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
// //     if (video != null) {
// //       mediaFiles.add(File(video.path));
// //     }

// //     setState(() {});
// //   }

// //   Future<void> _uploadPost() async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       List<String> downloadUrls = [];
// //       for (var file in mediaFiles) {
// //         String fileName = path.basename(file.path);
// //         Reference ref = FirebaseStorage.instance.ref().child('forum_media/$fileName');
// //         UploadTask task = ref.putFile(file);
// //         TaskSnapshot snapshot = await task;
// //         String url = await snapshot.ref.getDownloadURL();
// //         downloadUrls.add(url);
// //       }

// //       Map<String, dynamic> uploadedData = {
// //         'title': title,
// //         'description': description,
// //         'mediaUrls': downloadUrls,
// //         'timestamp': FieldValue.serverTimestamp(),

// //       };

// //       Navigator.of(context).pop();
// //     }
// //   }
// // }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:path/path.dart' as path;

// // class AddForumPostPage extends StatefulWidget {
// //   @override
// //   _AddForumPostPageState createState() => _AddForumPostPageState();
// // }

// // class _AddForumPostPageState extends State<AddForumPostPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   List<File> mediaFiles = [];
// //   final ImagePicker _picker = ImagePicker();
// //   String title = '';
// //   String description = '';

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Text("Add a Forum Post"),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(20),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: <Widget>[
// //               // Media selection button and display area
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: _selectMedia,
// //                     child: Text('Upload Media'),
// //                   ),
// //                   if (mediaFiles.isNotEmpty)
// //                     Text('${mediaFiles.length} file(s) selected'),
// //                 ],
// //               ),
// //               SizedBox(height: 20),
// //               // Title field
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'Title',
// //                   border: OutlineInputBorder(),
// //                   hintText: 'Enter the title of your post',
// //                 ),
// //                 onSaved: (value) => title = value!,
// //                 validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
// //               ),
// //               SizedBox(height: 20),
// //               // Description field
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'Description',
// //                   border: OutlineInputBorder(),
// //                   hintText: 'Enter a description',
// //                 ),
// //                 onSaved: (value) => description = value!,
// //                 validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
// //                 maxLines: 5,
// //               ),
// //               SizedBox(height: 20),
// //               // Submit button
// //               Center(
// //                 child: ElevatedButton(
// //                   onPressed: _uploadPost,
// //                   child: Text('Submit Post'),
// //                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _selectMedia() async {
// //     final List<XFile>? selectedFiles = await _picker.pickMultiImage();

// //     if (selectedFiles != null) {
// //       for (var file in selectedFiles) {
// //         mediaFiles.add(File(file.path));
// //       }
// //     }

// //     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
// //     if (video != null) {
// //       mediaFiles.add(File(video.path));
// //     }

// //     setState(() {});
// //   }

// //   Future<void> _uploadPost() async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //       List<String> downloadUrls = [];
// //       for (var file in mediaFiles) {
// //         String fileName = path.basename(file.path);
// //         Reference ref = FirebaseStorage.instance.ref().child('forum_media/$fileName');
// //         UploadTask task = ref.putFile(file);
// //         TaskSnapshot snapshot = await task;
// //         String url = await snapshot.ref.getDownloadURL();
// //         downloadUrls.add(url);
// //       }

// //       Map<String, dynamic> uploadedData = {
// //         'title': title,
// //         'description': description,
// //         'mediaUrls': downloadUrls,
// //         'timestamp': FieldValue.serverTimestamp(),
// //       };

// //       FirebaseFirestore.instance.collection('forums').add(uploadedData);
// //       Navigator.of(context).pop();
// //     }
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';

// import 'package:provider/provider.dart';

// import '../bottomNavigationBar.dart';

// class AddForumPage extends StatefulWidget {
//   @override
//   _AddForumPageState createState() => _AddForumPageState();
// }

// class _AddForumPageState extends State<AddForumPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final List<File> _mediaFiles = [];
//   bool _isLoading = false;

//   Future<void> _pickMedia() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? images = await picker.pickMultiImage();
//     final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

//     if (images != null) {
//       setState(() {
//         _mediaFiles.addAll(images.map((image) => File(image.path)).toList());
//       });
//     }

//     if (video != null) {
//       setState(() {
//         _mediaFiles.add(File(video.path));
//       });
//     }
//   }

//   Future<void> _uploadAndSubmit() async {
//     if (_titleController.text.isEmpty ||
//         _descriptionController.text.isEmpty ||
//         _mediaFiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Please fill all fields and select files to upload.')));
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       List<String> fileUrls = [];

//       for (File file in _mediaFiles) {
//         String fileName = file.path.split('/').last;
//         Reference storageRef =
//             FirebaseStorage.instance.ref().child('forum_uploads/$fileName');
//         UploadTask uploadTask = storageRef.putFile(file);
//         TaskSnapshot taskSnapshot = await uploadTask;
//         String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//         fileUrls.add(downloadUrl);
//       }

//       await FirebaseFirestore.instance.collection('forums').add({
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'fileUrls': fileUrls,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Forum post created successfully!')));
//       _titleController.clear();
//       _descriptionController.clear();
//       setState(() {
//         _mediaFiles.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to create forum post. Please try again.')));
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//       appBar: AppBar(
//         title: Text('Add Forum'),
//         backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: _pickMedia,
//                     child: Container(
//                       height: 150,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black26),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: _mediaFiles.isEmpty
//                           ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add_a_photo,
//                                       size: 50, color: Colors.black26),
//                                   SizedBox(height: 8),
//                                   Text('Click to upload images or videos',
//                                       style: TextStyle(color: Colors.black26)),
//                                 ],
//                               ),
//                             )
//                           : ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: _mediaFiles.length,
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Image.file(_mediaFiles[index],
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.cover),
//                                 );
//                               },
//                             ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     onTap: () {
//                       FocusScope.of(context).unfocus();
//                       context
//                           .read<BottomNavigationBarProvider>()
//                           .setFullScreen(true);
//                     },
//                     onEditingComplete: () {
//                       FocusScope.of(context).unfocus();
//                       context
//                           .read<BottomNavigationBarProvider>()
//                           .setFullScreen(false);
//                     },
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       labelText: 'Title',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     onTap: () {
//                       FocusScope.of(context).unfocus();
//                       context
//                           .read<BottomNavigationBarProvider>()
//                           .setFullScreen(true);
//                     },
//                     onEditingComplete: () {
//                       FocusScope.of(context).unfocus();
//                       context
//                           .read<BottomNavigationBarProvider>()
//                           .setFullScreen(false);
//                     },
//                     controller: _descriptionController,
//                     decoration: InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                   ),
//                   // SizedBox(height: 20),
//                   // ElevatedButton(
//                   //   onPressed: _uploadAndSubmit,
//                   //   child: Text(
//                   //     'Post',
//                   //     style: TextStyle(
//                   //       color: Color.fromRGBO(239, 255, 224, 1),
//                   //     ),
//                   //   ),
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Color.fromRGBO(161, 221, 104, 1),
//                   //     minimumSize: Size(double.infinity, 50),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color.fromRGBO(161, 221, 104, 1),
//         onPressed: _uploadAndSubmit,
//         child: Icon(
//           Icons.check,
//           color: Color.fromRGBO(239, 255, 224, 1),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../bottomNavigationBar.dart';

class AddForumPage extends StatefulWidget {
  @override
  _AddForumPageState createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _mediaFiles = [];
  bool _isLoading = false;
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        context.read<BottomNavigationBarProvider>().setFullScreen(false);
      }
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (images != null) {
      setState(() {
        _mediaFiles.addAll(images.map((image) => File(image.path)).toList());
      });
    }

    if (video != null) {
      setState(() {
        _mediaFiles.add(File(video.path));
      });
    }
  }

  Future<void> _uploadAndSubmit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _mediaFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill all fields and select files to upload.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> fileUrls = [];

      for (File file in _mediaFiles) {
        String fileName = file.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('forum_uploads/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        fileUrls.add(downloadUrl);
      }

      await FirebaseFirestore.instance.collection('forums').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'fileUrls': fileUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Forum post created successfully!')));
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _mediaFiles.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create forum post. Please try again.')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(239, 255, 224, 1),
      appBar: AppBar(
        title: Text('Add Forum'),
        backgroundColor: Color.fromRGBO(239, 255, 224, 1),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _mediaFiles.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.black26),
                                  SizedBox(height: 8),
                                  Text('Click to upload images or videos',
                                      style: TextStyle(color: Colors.black26)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _mediaFiles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(_mediaFiles[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onTap: () {
                      context
                          .read<BottomNavigationBarProvider>()
                          .setFullScreen(true);
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<BottomNavigationBarProvider>()
                          .setFullScreen(false);
                    },
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    focusNode: _descriptionFocusNode,
                    onTap: () {
                      context
                          .read<BottomNavigationBarProvider>()
                          .setFullScreen(true);
                    },
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(161, 221, 104, 1),
        onPressed: _uploadAndSubmit,
        child: Icon(
          Icons.check,
          color: Color.fromRGBO(239, 255, 224, 1),
        ),
      ),
    );
  }
}
