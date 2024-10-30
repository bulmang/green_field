class Recruit {
  String id;
  String creatorId;
  int remainTime;
  List<String> currentParticipants;
  int maxParticipants;
  String creatorCampus;
  bool isEntryAvailable;
  bool isTimeExpired;
  String title;
  String body;
  List<String>? images;
  DateTime createdAt;

  Recruit({
    required this.id,
    required this.creatorId,
    required this.remainTime,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.creatorCampus,
    required this.isEntryAvailable,
    required this.isTimeExpired,
    required this.title,
    required this.body,
    this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator_id': creatorId,
      'remain_time': remainTime,
      'current_participants': currentParticipants,
      'max_participants': maxParticipants,
      'creator_campus': creatorCampus,
      'is_entry_available': isEntryAvailable,
      'is_time_expired': isTimeExpired,
      'title': title,
      'body': body,
      'images': images ?? [],
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Recruit fromMap(Map<String, dynamic> map) {
    return Recruit(
      id: map['id'],
      creatorId: map['creator_id'],
      remainTime: map['remain_time'],
      currentParticipants: List<String>.from(map['current_participants'] ?? []),
      maxParticipants: map['max_participants'],
      creatorCampus: map['creator_campus'],
      isEntryAvailable: map['is_entry_available'],
      isTimeExpired: map['is_time_expired'],
      title: map['title'],
      body: map['body'],
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
