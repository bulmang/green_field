class User {
  String id;
  String simpleLoginId;
  String userType;
  String campus;
  String course;
  String name;
  DateTime? createDate;
  DateTime? lastLoginDate;

  User({
    required this.id,
    required this.simpleLoginId,
    this.userType = "student",
    required this.campus,
    required this.course,
    required this.name,
    this.createDate,
    this.lastLoginDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'simple_login_id': simpleLoginId,
      'user_type': userType,
      'campus': campus,
      'course': course,
      'name': name,
      'create_date': createDate?.toIso8601String(),
      'last_login_date': lastLoginDate?.toIso8601String(),
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      simpleLoginId: map['simple_login_id'],
      userType: map['user_type'] ?? "student",
      campus: map['campus'],
      course: map['course'],
      name: map['name'],
      createDate: map['create_date'] != null ? DateTime.parse(map['create_date']) : null,
      lastLoginDate: map['last_login_date'] != null ? DateTime.parse(map['last_login_date']) : null,
    );
  }
}
