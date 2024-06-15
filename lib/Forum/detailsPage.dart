import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracking/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String postId;

  DetailsPage({required this.postId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with WidgetsBindingObserver {
  late Future<DocumentSnapshot> _postFuture;
  bool _isKeyboardVisible = false;

  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _postFuture = FirebaseFirestore.instance
        .collection('forums')
        .doc(widget.postId)
        .get();

    _commentFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _commentFocusNode.removeListener(_handleFocusChange);
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_commentFocusNode.hasFocus) {
      context.read<BottomNavigationBarProvider>().setFullScreen(true);
    } else {
      setState(() {
        context.read<BottomNavigationBarProvider>().setFullScreen(false);
      });
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: _postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error");
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                data['title'],
                style:
                    TextStyle(fontFamily: "Inika", fontWeight: FontWeight.bold),
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
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
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
                      bool isVideo =
                          url.contains('.mp4') || url.contains('.mov');
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: isVideo
                            ? VideoPlayerWidget(url: url)
                            : Image.network(url, fit: BoxFit.cover),
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
                if (!_isKeyboardVisible)
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          LikeButton(postId: widget.postId),
                          SizedBox(width: 10), // Add spacing between buttons
                          CommentButton(
                              postId: widget.postId,
                              commentFocusNode: _commentFocusNode),
                          SizedBox(width: 10),
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

class LikeButton extends StatefulWidget {
  final String postId;

  LikeButton({required this.postId});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle user not signed in
      print("User not signed in");
      return;
    }

    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('forums')
        .doc(widget.postId)
        .get();
    if (!postSnapshot.exists) {
      throw Exception("Post does not exist!");
    }

    List<dynamic> likes = postSnapshot['likeId'] ?? [];
    setState(() {
      isLiked = likes.contains(user.uid);
      likeCount = likes.length;
    });
  }

  void _handleLike() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle user not signed in
      print("User not signed in");
      return;
    }

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('forums').doc(widget.postId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      List<dynamic> likes = postSnapshot['likeId'] ?? [];
      if (likes.contains(user.uid)) {
        // User already liked the post, so unlike it
        likes.remove(user.uid);
      } else {
        // User has not liked the post, so add their like
        likes.add(user.uid);
      }

      transaction.update(postRef, {
        'likeId': likes,
        'likes': likes.length,
      });

      setState(() {
        isLiked = !isLiked;
        likeCount = likes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
            color: isLiked ? Colors.blue : null,
          ),
          onPressed: _handleLike,
        ),
        Text('$likeCount'),
      ],
    );
  }
}

class CommentButton extends StatelessWidget {
  final String postId;
  final FocusNode commentFocusNode;

  CommentButton({required this.postId, required this.commentFocusNode});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.comment_outlined),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => CommentSection(
              postId: postId, commentFocusNode: commentFocusNode),
        );
      },
    );
  }
}

class CommentSection extends StatefulWidget {
  final String postId;
  final FocusNode commentFocusNode;

  CommentSection({required this.postId, required this.commentFocusNode});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController _commentController = TextEditingController();

  Future<void> _addComment(String comment) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle user not signed in
      print("User not signed in");
      return;
    }

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('forums').doc(widget.postId);
    await postRef.collection('comments').add({
      'comment': comment,
      'userId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
    widget.commentFocusNode
        .unfocus(); // Unfocus the text field to hide the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forums')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment = comments[index];
                    return ListTile(
                      title: Text(comment['comment']),
                      subtitle: Text(comment[
                          'userId']), // Ideally, you would resolve the userId to a user name
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: widget.commentFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment(_commentController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
