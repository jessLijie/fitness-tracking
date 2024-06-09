// // import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:flutter/material.dart';

// // class DetailsPage extends StatelessWidget {
// //   final String title;
// //   final String description;
// //   final String imageUrl;

// //   DetailsPage({
// //     required this.title,
// //     required this.description,
// //     required this.imageUrl,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           title,
// //           style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
// //         ),
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           Expanded(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: <Widget>[
// //                   CarouselSlider(
// //                     items: forum.media.map((item) {
// //                       return Builder(
// //                         builder: (BuildContext context) {
// //                           return Container(
// //                             width: MediaQuery.of(context).size.width,
// //                             margin: EdgeInsets.symmetric(horizontal: 5.0),
// //                             child: Image.network(item, fit: BoxFit.cover),
// //                           );
// //                         },
// //                       );
// //                     }).toList(),
// //                     options: CarouselOptions(
// //                       autoPlay: false,
// //                       enlargeCenterPage: true,
// //                       viewportFraction: 0.9,
// //                       aspectRatio: 2.0,
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(16.0),
// //                     child: Text(
// //                       description,
// //                       style: TextStyle(fontSize: 16.0),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Divider(height: 1),
// //           // Bottom action buttons
// //           SafeArea(
// //             child: Container(
// //               padding:
// //                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: <Widget>[
// //                   IconButton(
// //                     icon: Icon(Icons.thumb_up_alt_outlined),
// //                     onPressed: () {
// //                       // Bookmark the recipe
// //                     },
// //                   ),
// //                   IconButton(
// //                     icon: Icon(Icons.bookmark_border_outlined),
// //                     onPressed: () {
// //                       // Comment on the recipe
// //                     },
// //                   ),
// //                   IconButton(
// //                     icon: Icon(Icons.comment_outlined),
// //                     onPressed: () {
// //                       // Share the recipe
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:fitness_tracking/bottomNavigationBar.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class DetailsPage extends StatelessWidget {
//   final String postId;

//   DetailsPage({required this.postId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //bottomNavigationBar: NavigationBarApp(),
//       appBar: AppBar(title: Text("Post Details")),
//       body: FutureBuilder<DocumentSnapshot>(
//         future:
//             FirebaseFirestore.instance.collection('forums').doc(postId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             Map<String, dynamic> data =
//                 snapshot.data!.data() as Map<String, dynamic>;
//             return Column(
//               children: [
//                 Text(data['title'],
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text(data['description']),
//                 Expanded(
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       autoPlay: false,
//                       enlargeCenterPage: true,
//                       viewportFraction: 0.9,
//                       aspectRatio: 2.0,
//                     ),
//                     items: List.generate(data['mediaUrls'].length, (index) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         child: Image.network(data['mediaUrls'][index],
//                             fit: BoxFit.cover),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           }
//           return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:video_player/video_player.dart';

// class DetailsPage extends StatelessWidget {
//   final String postId;

//   DetailsPage({required this.postId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<DocumentSnapshot>(
//           future: FirebaseFirestore.instance.collection('forums').doc(postId).get(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasError) {
//                 return Text("Error");
//               }
//               Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//               return Text(
//                 data['title'],
//                 style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
//               );
//             }
//             return Text("Loading...");
//           },
//         ),
//         backgroundColor: Color.fromRGBO(239, 255, 224, 1),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('forums').doc(postId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//             Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//             List<String> mediaUrls = List<String>.from(data['fileUrls']);
//             return Column(
//               children: [
//                 Expanded(
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       autoPlay: false,
//                       enlargeCenterPage: true,
//                       viewportFraction: 0.9,
//                       aspectRatio: 2.0,
//                     ),
//                     items: mediaUrls.map((url) {
//                       bool isVideo = url.endsWith('.mp4') || url.endsWith('.mov');
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         child: isVideo ? VideoPlayerWidget(url: url) : Image.network(url, fit: BoxFit.cover),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     data['description'],
//                     style: TextStyle(fontSize: 16.0, fontFamily: "Inika"),
//                   ),
//                 ),
//                 Divider(height: 1),
//                 SafeArea(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.thumb_up_alt_outlined),
//                           onPressed: () {
//                             // Handle like functionality
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.bookmark_border_outlined),
//                           onPressed: () {
//                             // Handle save functionality
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.comment_outlined),
//                           onPressed: () {
//                             // Handle comment functionality
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String url;

//   VideoPlayerWidget({required this.url});

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : Center(child: CircularProgressIndicator());
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

class DetailsPage extends StatelessWidget {
  final String postId;

  DetailsPage({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('forums').doc(postId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error");
              }
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                data['title'],
                style: TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
              );
            }
            return Text("Loading...");
          },
        ),
        backgroundColor: Color.fromRGBO(239, 255, 224, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('forums').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            List<String> mediaUrls = List<String>.from(data['fileUrls']);
            double screenHeight = MediaQuery.of(context).size.height;
            double carouselHeight = screenHeight / 2;

            return ListView(
              children: [
                Container(
                  height: carouselHeight,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      height: carouselHeight,
                    ),
                    items: mediaUrls.map((url) {
                      bool isVideo = url.endsWith('.mp4') || url.endsWith('.mov');
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: isVideo ? VideoPlayerWidget(url: url) : Image.network(url, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    data['description'],
                    style: TextStyle(fontSize: 16.0, fontFamily: "Inika"),
                  ),
                ),
                Divider(height: 1),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up_alt_outlined),
                          onPressed: () {
                            // Handle like functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border_outlined),
                          onPressed: () {
                            // Handle save functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.comment_outlined),
                          onPressed: () {
                            // Handle comment functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _isError = false;
        });
      }).catchError((error) {
        setState(() {
          _isError = true;
        });
        print("VideoPlayer error: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Center(child: CircularProgressIndicator()),
        if (_isError)
          Center(
            child: Text(
              "Failed to load video",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
      ],
    );
  }
}
