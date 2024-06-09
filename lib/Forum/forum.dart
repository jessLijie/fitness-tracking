class Forum {
  late int id;
  late String userId;
  late DateTime timestamp;
  late String title;
  late String? description;
  late List<String> mediaUrls;
  late List<String> likeIds;
  late int likes;
  late List<Map<String, dynamic>> comments;

  Forum({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.likeIds,
    this.likes = 0,
    List<Map<String, dynamic>>? comments,
  }) : comments = comments ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp,
      'title': title,
      'description': description,
      'mediaUrls': mediaUrls,
      'likeIds': likeIds,
      'likes': likes,
      'comments': comments.map((comment) => comment).toList(),
    };
  }

  static Forum fromMap(Map<String, dynamic> map) {
    return Forum(
        id: map['id'],
        userId: map['userId'],
        timestamp: DateTime.parse(map['timestamp']),
        title: map['title'],
        description: map['description'] ?? '',
        mediaUrls: List<String>.from(map['mediaUrls']),
        likeIds: map['likeIds'],
        likes: map['likes'] ?? 0,
        comments: List<Map<String, dynamic>>.from(map['comments'] ?? []),
        
    );
  }
}
