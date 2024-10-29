class Notice {
  String id;
  String creatorId;
  String userCampus;
  String title;
  String body;
  List<String> like;
  List<String>? images;
  DateTime createdAt;

  Notice({
    required this.id,
    required this.creatorId,
    required this.userCampus,
    required this.title,
    required this.body,
    required this.like,
    this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator_id': creatorId,
      'user_campus': userCampus,
      'title': title,
      'body': body,
      'like': like,
      'images': images ?? [],
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Notice fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'],
      creatorId: map['creator_id'],
      userCampus: map['user_campus'],
      title: map['title'],
      body: map['body'],
      like: List<String>.from(map['like'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
