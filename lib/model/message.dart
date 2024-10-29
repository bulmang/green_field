class Message {
  String id;
  String roomId;
  String userId;
  String userName;
  String text;
  DateTime createdAt;

  Message({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'user_id': userId,
      'user_name': userName,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      roomId: map['room_id'],
      userId: map['user_id'],
      userName: map['user_name'],
      text: map['text'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
