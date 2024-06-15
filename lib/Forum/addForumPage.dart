import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../bottomNavigationBar.dart';

class AddForumPage extends StatefulWidget {
  @override
  _AddForumPageState createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<File> _mediaFiles = [];
  final List<String> _tags = [];
  bool _isLoading = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode.addListener(_handleFocusChange);
    _titleFocusNode.addListener(_handleFocusChange);
    _tagFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _descriptionFocusNode.removeListener(_handleFocusChange);
    _titleFocusNode.removeListener(_handleFocusChange);
    _tagFocusNode.removeListener(_handleFocusChange);
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _tagFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_titleFocusNode.hasFocus ||
        _descriptionFocusNode.hasFocus ||
        _tagFocusNode.hasFocus) {
      context.read<BottomNavigationBarProvider>().setFullScreen(true);
    } else {
      context.read<BottomNavigationBarProvider>().setFullScreen(false);
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(
                'Photo',
                style: TextStyle(
                  fontFamily: "Inika",
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final List<XFile>? images =
                    await ImagePicker().pickMultiImage();
                if (images != null) {
                  setState(() {
                    for (var image in images) {
                      File file = File(image.path);
                      if (!_mediaFiles.contains(file)) {
                        _mediaFiles.add(file);
                      }
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text(
                'Video',
                style: TextStyle(
                  fontFamily: "Inika",
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final XFile? video =
                    await ImagePicker().pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  File file = File(video.path);
                  if (!_mediaFiles.contains(file)) {
                    setState(() {
                      _mediaFiles.add(file);
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _generateThumbnail(File file) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    return thumbnail;
  }

  Future<void> _uploadAndSubmit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _mediaFiles.isEmpty ||
        _tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields, add tags, and select files to upload.',
            style: TextStyle(
              fontFamily: "Inika",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<BottomNavigationBarProvider>().setFullScreen(false);

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> fileUrls = [];
      List<String> thumbnailUrls = [];
      final User? currentUser =
          FirebaseAuth.instance.currentUser; // Get the current user
      final String? uid = currentUser?.uid; // Get the current user's UID
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (File file in _mediaFiles) {
        String fileName = '${timestamp}_${file.path.split('/').last}';
        String filePath =
            'forum_media/$uid/$fileName'; // Create file path with UID and timestamp
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        fileUrls.add(downloadUrl);

        if (file.path.endsWith('.mp4') || file.path.endsWith('.mov')) {
          Uint8List? thumbnailData = await _generateThumbnail(file);
          if (thumbnailData != null) {
            Reference thumbnailRef = FirebaseStorage.instance.ref().child(
                'forum_media/$uid/thumbnails/${timestamp}_${file.path.split('/').last}.jpg');
            UploadTask thumbnailUploadTask =
                thumbnailRef.putData(thumbnailData);
            TaskSnapshot thumbnailTaskSnapshot = await thumbnailUploadTask;
            String thumbnailUrl =
                await thumbnailTaskSnapshot.ref.getDownloadURL();
            thumbnailUrls.add(thumbnailUrl);
          } else {
            thumbnailUrls.add(
                downloadUrl); // Add the original URL if thumbnail generation fails
          }
        } else {
          thumbnailUrls
              .add(downloadUrl); // Use the original image URL as the thumbnail
        }
      }

      await FirebaseFirestore.instance.collection('forums').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'fileUrls': fileUrls,
        'thumbnailUrls': thumbnailUrls,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': uid, // Add the UID to the document data
        'tags': _tags, // Add tags
        'likes': 0,
        'likeId': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Forum post created successfully!',
            style: TextStyle(
              fontFamily: "Inika",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      _titleController.clear();
      _descriptionController.clear();
      _tagController.clear();
      setState(() {
        _mediaFiles.clear();
        _tags.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create forum post. Please try again.',
            style: TextStyle(
              fontFamily: "Inika",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addTag() {
    final String tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Widget _buildMediaPreview(File file) {
    final isVideo = file.path.endsWith('.mp4') || file.path.endsWith('.mov');
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isVideo
              ? FutureBuilder<String?>(
                  future: VideoThumbnail.thumbnailFile(
                    video: file.path,
                    imageFormat: ImageFormat.JPEG,
                    maxWidth: 128,
                    quality: 25,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Image.file(
                        File(snapshot.data!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.black26,
                        child: Center(
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                )
              : Image.file(
                  file,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _mediaFiles.remove(file);
              });
            },
            child: Container(
              color: Colors.black54,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(tag),
      onDeleted: () {
        setState(() {
          _tags.remove(tag);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(239, 255, 224, 1),
      appBar: AppBar(
        title: Text(
          'Add Forum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
                                  Text(
                                    'Click to upload images or videos',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontFamily: "Inika",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _mediaFiles.length,
                              itemBuilder: (context, index) {
                                return _buildMediaPreview(_mediaFiles[index]);
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    focusNode: _titleFocusNode,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Enter your title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    focusNode: _descriptionFocusNode,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description here',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    focusNode: _tagFocusNode,
                    controller: _tagController,
                    decoration: InputDecoration(
                      labelText: 'Add a tag',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addTag,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: _tags.map((tag) => _buildTagChip(tag)).toList(),
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
