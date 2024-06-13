// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/detailsPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 255, 224, 1),
        appBar: AppBar(
          title: Text(
            'Forum',
            style: TextStyle(
              fontFamily: "Inika",
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromRGBO(239, 255, 224, 1),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Forums'),
              Tab(text: 'My Forums'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllForumsTab(),
            MyForumsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddForumPage();
            }));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AllForumsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(height: 1.0),
            onSubmitted: (value) {
              // Implement search functionality
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(
              7,
              (int index) {
                return Chip(
                  label: Text(
                    '#Tag ${index + 1}',
                    style: TextStyle(
                      fontFamily: "Inika",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('forums').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No forum found',
                      style: TextStyle(
                          fontFamily: "Inika", fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ForumItem(
                      id: document.id,
                      title: data['title'],
                      thumbnailUrls: List<String>.from(data['thumbnailUrls']),
                      description: data['description'],
                      isMyForum: false,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyForumsTab extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('forums')
                  .where('uid', isEqualTo: currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No forum found',
                      style: TextStyle(
                          fontFamily: "Inika", fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ForumItem(
                      id: document.id,
                      title: data['title'],
                      thumbnailUrls: List<String>.from(data['thumbnailUrls']),
                      description: data['description'],
                      isMyForum: true,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ForumItem extends StatelessWidget {
  final String id;
  final String title;
  final List<String>? thumbnailUrls;
  final String description;
  final bool isMyForum;

  ForumItem({
    required this.id,
    required this.title,
    this.thumbnailUrls,
    required this.description,
    required this.isMyForum,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageHeight = width / 3;
    String? firstThumbnailUrl =
        (thumbnailUrls != null && thumbnailUrls!.isNotEmpty) ? thumbnailUrls!.first : null;

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () {
          navigateToDetails(context, id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstThumbnailUrl != null && firstThumbnailUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  firstThumbnailUrl,
                  width: width,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: width,
                    height: imageHeight,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ListTile(
              title: Text(
                title,
                style: TextStyle(fontSize: 20.0, fontFamily: "Inika"),
              ),
              subtitle: Text(
                description.length > 100
                    ? '${description.substring(0, 97)}...'
                    : description,
                style: TextStyle(
                    fontSize: 12.0, color: Color.fromRGBO(80, 80, 80, 0.7)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'See more',
                      style: TextStyle(color: Color.fromRGBO(121, 207, 41, 1)),
                    ),
                    onPressed: () {
                      navigateToDetails(context, id);
                    },
                  ),
                  if (isMyForum)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigate to EditForumPage with the current forum data
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditForumPage(
                                id: id,
                                title: title,
                                description: description,
                                thumbnailUrls: thumbnailUrls,
                              ),
                            ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Delete the forum
                            _deleteForum(context, id);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToDetails(BuildContext context, String forumId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(postId: forumId),
      ),
    );
  }

  void _deleteForum(BuildContext context, String forumId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Forum'),
          content: Text('Are you sure you want to delete this forum?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('forums')
                    .doc(forumId)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Forum deleted successfully')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete forum: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class EditForumPage extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final List<String>? thumbnailUrls;

  EditForumPage({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrls,
  });

  @override
  _EditForumPageState createState() => _EditForumPageState();
}

class _EditForumPageState extends State<EditForumPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final List<File> _newMediaFiles = [];
  List<String> _existingMediaUrls = [];
  bool _isLoading = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    if (widget.thumbnailUrls != null) {
      _existingMediaUrls = List.from(widget.thumbnailUrls!);
    }
    _descriptionFocusNode.addListener(_handleFocusChange);
    _titleFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _descriptionFocusNode.removeListener(_handleFocusChange);
    _titleFocusNode.removeListener(_handleFocusChange);
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_titleFocusNode.hasFocus || _descriptionFocusNode.hasFocus) {
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
              title: Text('Photo', style: TextStyle(fontFamily: "Inika")),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final List<XFile>? images =
                    await ImagePicker().pickMultiImage();
                if (images != null) {
                  setState(() {
                    for (var image in images) {
                      File file = File(image.path);
                      if (!_newMediaFiles.contains(file)) {
                        _newMediaFiles.add(file);
                      }
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Video', style: TextStyle(fontFamily: "Inika")),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final XFile? video =
                    await ImagePicker().pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  File file = File(video.path);
                  if (!_newMediaFiles.contains(file)) {
                    setState(() {
                      _newMediaFiles.add(file);
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

  Future<void> _uploadAndSubmit() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields.',
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

      for (File file in _newMediaFiles) {
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

      // Combine existing and new media URLs
      List<String> combinedFileUrls = List.from(_existingMediaUrls)
        ..addAll(fileUrls);
      List<String> combinedThumbnailUrls = List.from(_existingMediaUrls)
        ..addAll(thumbnailUrls);

      await FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.id)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'fileUrls': combinedFileUrls,
        'thumbnailUrls': combinedThumbnailUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Forum updated successfully!',
            style: TextStyle(
              fontFamily: "Inika",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update forum. Please try again.',
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

  Future<Uint8List?> _generateThumbnail(File file) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    return thumbnail;
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
                _newMediaFiles.remove(file);
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

  Widget _buildExistingMediaPreview(String url) {
    final isVideo = url.endsWith('.mp4') || url.endsWith('.mov');
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isVideo
              ? Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  ),
                )
              : Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  ),
                ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _existingMediaUrls.remove(url);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(239, 255, 224, 1),
      appBar: AppBar(
        title: Text(
          'Edit Forum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(239, 255, 224, 1),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _pickMedia,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _newMediaFiles.isEmpty &&
                                _existingMediaUrls.isEmpty
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
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ..._existingMediaUrls
                                      .map(_buildExistingMediaPreview),
                                  ..._newMediaFiles.map(_buildMediaPreview),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      focusNode: _titleFocusNode,
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadAndSubmit,
                      child: Text('Update Forum'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
