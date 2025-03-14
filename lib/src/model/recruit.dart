class Recruit {
  String id;
  String creatorId;
  DateTime remainTime; // Changed to DateTime
  List<String> currentParticipants;
  int maxParticipants;
  String creatorCampus;
  bool isEntryAvailable;
  String title;
  String body;
  List<String>? images;
  List<String> reportedUsers;
  DateTime createdAt;

  Recruit({
    required this.id,
    required this.creatorId,
    required this.remainTime,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.creatorCampus,
    required this.isEntryAvailable,
    required this.title,
    required this.body,
    this.images,
    this.reportedUsers = const [],
    required this.createdAt,
  });

  factory Recruit.create({
    required String id,
    required String creatorId,
    required int minutes,
    required List<String> currentParticipants,
    required int maxParticipants,
    required String creatorCampus,
    required bool isEntryAvailable,
    required String title,
    required String body,
    List<String>? images,
    List<String> reportedUsers = const [],
    required DateTime createdAt,
  }) {
    final DateTime expirationTime = DateTime.now().add(Duration(minutes: minutes));
    return Recruit(
      id: id,
      creatorId: creatorId,
      remainTime: expirationTime,
      currentParticipants: currentParticipants,
      maxParticipants: maxParticipants,
      creatorCampus: creatorCampus,
      isEntryAvailable: isEntryAvailable,
      title: title,
      body: body,
      images: images,
      reportedUsers: reportedUsers,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creator_id': creatorId,
      'remain_time': remainTime.toIso8601String(),
      'current_participants': currentParticipants,
      'max_participants': maxParticipants,
      'creator_campus': creatorCampus,
      'is_entry_available': isEntryAvailable,
      'title': title,
      'body': body,
      'images': images ?? [],
      'reported_users': reportedUsers,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Recruit fromMap(Map<String, dynamic> map) {
    return Recruit(
      id: map['id'],
      creatorId: map['creator_id'],
      remainTime: DateTime.parse(map['remain_time']), // Parse ISO8601 string back to DateTime
      currentParticipants: List<String>.from(map['current_participants'] ?? []),
      maxParticipants: map['max_participants'],
      creatorCampus: map['creator_campus'],
      isEntryAvailable: map['is_entry_available'],
      title: map['title'],
      body: map['body'],
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      reportedUsers: List<String>.from(map['reported_users'] ?? []),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
