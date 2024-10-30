
class Report {
  String id;
  String type;
  String reportedTargetID;
  String reporterId;
  DateTime createdAt;

  Report({
    required this.id,
    required this.type,
    required this.reportedTargetID,
    required this.reporterId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'reported_target': reportedTargetID,
      'reporter_id': reporterId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Report fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      type: map['type'],
      reportedTargetID: map['reported_target'],
      reporterId: map['reporter_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
