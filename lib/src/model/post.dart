import 'comment.dart';

class Post {
  String id;
  String creatorId;
  String creatorCampus;
  DateTime createdAt;
  String title;
  String body;
  List<String> like;
  List<String>? images;
  int commentCount;
  List<String> reportedUsers;
  List<String> commentId;

  Post({
    required this.id,
    required this.creatorId,
    required this.creatorCampus,
    required this.createdAt,
    required this.title,
    required this.body,
    required this.like,
    this.images,
    required this.commentCount,
    this.reportedUsers = const [],
    this.commentId = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator_id': creatorId,
      'creator_campus': creatorCampus,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'body': body,
      'like': like,
      'images': images,
      'commentCount': commentCount,
      'reported_users': reportedUsers,
      'comment_id': commentId,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      creatorId: map['creator_id'],
      creatorCampus: map['creator_campus'],
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'],
      body: map['body'],
      like: List<String>.from(map['like'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      commentCount: map['commentCount'],
      reportedUsers: List<String>.from(map['reported_users'] ?? []),
      commentId: List<String>.from(map['comment_id'] ?? []),
    );
  }
}
