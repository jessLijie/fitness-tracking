import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/detailsPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:collection/collection.dart'; // For the take function

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

class AllForumsTab extends StatefulWidget {
  @override
  _AllForumsTabState createState() => _AllForumsTabState();
}

class _AllForumsTabState extends State<AllForumsTab> {
  String _searchQuery = '';
  String _selectedTag = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(height: 1.0),
            onSubmitted: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('forums').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              // Extract tags from all forum documents
              final allTags = snapshot.data!.docs
                  .map((doc) => doc['tags'] as List<dynamic>)
                  .expand((tags) => tags)
                  .toSet()
                  .toList();

              // Shuffle and take the first 6 tags
              allTags.shuffle();
              final displayedTags = allTags.take(6).toList();

              return Wrap(
                spacing: 8.0,
                children: displayedTags.map((tag) {
                  return ChoiceChip(
                    label: Text(
                      tag.toString(),
                      style: TextStyle(
                        fontFamily: "Inika",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _selectedTag == tag,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedTag = selected ? tag : '';
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('forums').snapshots(),
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

                // Filter the forums based on the search query and selected tag
                var filteredForums = snapshot.data!.docs.where((document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  String title = data['title'].toString().toLowerCase();
                  String description =
                      data['description'].toString().toLowerCase();
                  String searchQuery = _searchQuery.toLowerCase();
                  bool matchesQuery = title.contains(searchQuery) ||
                      description.contains(searchQuery);
                  bool matchesTag = _selectedTag.isEmpty ||
                      (data['tags'] as List<dynamic>).contains(_selectedTag);
                  return matchesQuery && matchesTag;
                }).toList();

                if (filteredForums.isEmpty) {
                  return Center(
                    child: Text(
                      'No forum matches the search criteria',
                      style: TextStyle(
                          fontFamily: "Inika", fontWeight: FontWeight.bold),
                    ),
                  );
                }

                return ListView(
                  children: filteredForums.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ForumItem(
                      id: document.id,
                      title: data['title'],
                      thumbnailUrls: List<String>.from(data['thumbnailUrls']),
                      description: data['description'],
                      tags: List<String>.from(data['tags']),
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ForumItem(
                      id: document.id,
                      title: data['title'],
                      thumbnailUrls: List<String>.from(data['thumbnailUrls']),
                      description: data['description'],
                      tags: List<String>.from(data['tags']),
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
  final List<String> tags;
  final bool isMyForum;

  ForumItem({
    required this.id,
    required this.title,
    this.thumbnailUrls,
    required this.description,
    required this.tags,
    required this.isMyForum,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageHeight = width / 3;
    String? firstThumbnailUrl =
        (thumbnailUrls != null && thumbnailUrls!.isNotEmpty)
            ? thumbnailUrls!.first
            : null;

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
              child: Wrap(
                spacing: 6.0,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        fontFamily: "Inika",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
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
                              builder: (context) => AddForumPage(),
                            ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Delete the forum
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete this forum?'),
                                  actions: [
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
                                            .doc(id)
                                            .delete()
                                            .then((_) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(postId: forumId),
      ),
    );
  }
}
