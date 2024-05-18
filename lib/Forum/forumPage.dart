// import 'package:fitness_tracking/Forum/addForumPage.dart';
// import 'package:fitness_tracking/Forum/detailsPage.dart';
// import 'package:flutter/material.dart';

// class ForumPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//       appBar: AppBar(
//         title: Text(
//           'Forum',
//           style: TextStyle(
//             fontFamily: "Inika",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.add),
//         //     onPressed: () {
//         //       // Handle add action
//         //     },
//         //   ),
//         // ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: <Widget>[
//             // 2. TextField for search function outside of AppBar
//             TextField(
//               style: TextStyle(height: 1.0),
//               onSubmitted: (value) {
//                 // Implement search functionality
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 suffixIcon:
//                     IconButton(onPressed: () {}, icon: Icon(Icons.search)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             SizedBox(height: 10.0), // Spacing between search and tags
//             Wrap(
//               spacing: 8.0,
//               children: List<Widget>.generate(
//                 7,
//                 (int index) {
//                   return Chip(
//                     label: Text('#Tag ${index + 1}'),
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   RecipeItem(
//                     title: 'Recipe #1',
//                     imageUrl: 'assets/image/salad.jpg',
//                     description:
//                         'A fresh salad with mixed greens, tomatoes, cucumbers, and a tangy dressing.',
//                   ),
//                   RecipeItem(
//                     title: 'Recipe #2',
//                     imageUrl: 'assets/image/salad.jpg',
//                     description:
//                         'Delicious homemade pizza with a crispy crust, fresh tomatoes, and melted cheese.',
//                   ),
//                   RecipeItem(
//                     title: 'Recipe #3',
//                     imageUrl: 'assets/image/salad.jpg',
//                     description:
//                         'Spaghetti with a savory meat sauce and grated parmesan on top.',
//                   ),
//                 ],
//               ),
//             ),
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AddForumPostPage()));
//               },
//               child: Icon(Icons.add),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void navigateToDetails(
//       BuildContext context, String title, String description, String imageUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailsPage(
//           title: title,
//           description: description,
//           imageUrl: imageUrl,
//         ),
//       ),
//     );
//   }

//   // void detailsPage(BuildContext context) {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => DetailsPage()),
//   //   );
//   // }
// }

// // The RecipeItem class remains unchanged

// class RecipeItem extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final String description;

//   RecipeItem({
//     required this.title,
//     required this.imageUrl,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Determine the size for responsiveness
//     double width = MediaQuery.of(context).size.width;
//     double imageHeight = width / 3; // For example, a 1:3 aspect ratio

//     return Card(
//       elevation: 5.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Use the dedicated navigateToDetails function directly within the onTap callback
//           navigateToDetails(context, title, description, imageUrl);
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//               child: Image.asset(
//                 imageUrl,
//                 width: width, // Make the image fill the card width
//                 height: imageHeight, // Fixed height for all images
//                 fit: BoxFit.cover, // Cover ensures the image fills the space
//               ),
//             ),
//             ListTile(
//               title: Text(
//                 title,
//                 style: TextStyle(fontSize: 20.0, fontFamily: "Inika"),
//               ),
//               subtitle: Text(
//                 description.length > 100
//                     ? '${description.substring(0, 97)}...'
//                     : description,
//                 style: TextStyle(
//                     fontSize: 12.0, color: Color.fromRGBO(80, 80, 80, 0.7)),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextButton(
//                 child: Text(
//                   'See more',
//                   style: TextStyle(color: Color.fromRGBO(121, 207, 41, 1)),
//                 ),
//                 onPressed: () {
//                   // Use the dedicated navigateToDetails function directly within the onPressed callback
//                   navigateToDetails(context, title, description, imageUrl);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Extract the navigation logic into a method that can be used in onTap and onPressed
//   void navigateToDetails(
//       BuildContext context, String title, String description, String imageUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailsPage(
//           title: title,
//           description: description,
//           imageUrl: imageUrl,
//         ),
//       ),
//     );
//   }
// }

// import 'package:fitness_tracking/Forum/addForumPage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'detailsPage.dart';

// class ForumPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//       appBar: AppBar(
//         title: Text(
//           "Forum",
//           style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('forums').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(data['title']),
//                 subtitle: Text(data['description']),
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => DetailsPage(postId: document.id),
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => AddForumPostPage()),
//         ),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:fitness_tracking/Forum/addForumPage.dart';
import 'package:fitness_tracking/Forum/detailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracking/router.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Padding(
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
                suffixIcon:
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
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
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic>? data =
                          document.data()! as Map<String, dynamic>;
                      return RecipeItem(
                        id: document.id,
                        title: data['title'],
                        imageUrl: data['imageUrl'],
                        description: data['description'],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddForumPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecipeItem extends StatelessWidget {
  final String id;
  final String title;
  final String? imageUrl;
  final String description;

  RecipeItem({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageHeight = width / 3;

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
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: imageUrl.toString().isNotEmpty
                  ? Image.asset("assets/image/salad.jpg")
                  : Image.network(
                      imageUrl.toString(),
                      width: width,
                      height: imageHeight,
                      fit: BoxFit.cover,
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
              child: TextButton(
                child: Text(
                  'See more',
                  style: TextStyle(color: Color.fromRGBO(121, 207, 41, 1)),
                ),
                onPressed: () {
                  navigateToDetails(context, id);
                },
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
}
