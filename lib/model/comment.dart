class Comment {
  String id;
  String creatorId;
  String creatorCampus;
  String body;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.creatorId,
    required this.creatorCampus,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator_id': creatorId,
      'creator_campus': creatorCampus,
      'body': body,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Comment fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      creatorId: map['creator_id'],
      creatorCampus: map['creator_campus'],
      body: map['body'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
