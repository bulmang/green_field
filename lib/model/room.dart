class Room {
  String id;
  String recruitId;
  int remainTime;
  String ownerId;
  List<String> userList;
  bool isTimeExpired;
  DateTime createdAt;

  Room({
    required this.id,
    required this.recruitId,
    required this.remainTime,
    required this.ownerId,
    required this.userList,
    required this.isTimeExpired,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recruit_id': recruitId,
      'remain_time': remainTime,
      'owner': ownerId,
      'user_list': userList,
      'is_time_expired': isTimeExpired,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      recruitId: map['recruit_id'],
      remainTime: map['remain_time'],
      ownerId: map['owner'],
      userList: List<String>.from(map['user_list'] ?? []),
      isTimeExpired: map['is_time_expired'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
