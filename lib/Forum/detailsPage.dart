import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  DetailsPage({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset(imageUrl),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          // Bottom action buttons
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {
                      // Bookmark the recipe
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.bookmark_border_outlined),
                    onPressed: () {
                      // Comment on the recipe
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment_outlined),
                    onPressed: () {
                      // Share the recipe
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}