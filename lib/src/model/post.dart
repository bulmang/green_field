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
  List<Comment> comment;
  List<String> reportedUsers;

  Post({
    required this.id,
    required this.creatorId,
    required this.creatorCampus,
    required this.createdAt,
    required this.title,
    required this.body,
    required this.like,
    this.images,
    comment,
    this.reportedUsers = const [],
  }) : comment = List.from(comment ?? []);

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
      'comment': comment,
      'reported_users': reportedUsers,
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
      comment: List<Comment>.from(map['comment'] ?? []),
      reportedUsers: List<String>.from(map['reported_users'] ?? []),
    );
  }
}
