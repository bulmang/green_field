class User {
  String id;
  String providerId;
  String userType;
  String campus;
  String course;
  String name;
  DateTime? createDate;
  DateTime? lastSignInDate;
  DateTime? lastLoginInDate;

  User({
    required this.id,
    required this.providerId,
    this.userType = "student",
    required this.campus,
    required this.course,
    required this.name,
    this.createDate,
    this.lastSignInDate,
    this.lastLoginInDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'simple_login_id': providerId,
      'user_type': userType,
      'campus': campus,
      'course': course,
      'name': name,
      'create_date': createDate?.toIso8601String(),
      'last_signin_date': lastSignInDate?.toIso8601String(),
      'last_login_date': lastSignInDate?.toIso8601String(),
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    // null 체크 및 기본값 설정
    String id = map['id'] ?? '';
    String simpleLoginId = map['simple_login_id'] ?? 'unknown';
    String campus = map['campus'] ?? 'unknown';
    String course = map['course'] ?? 'unknown';
    String name = map['name'] ?? 'unknown';

    return User(
      id: id,
      providerId: simpleLoginId,
      userType: map['user_type'] ?? "student",
      campus: campus,
      course: course,
      name: name,
      createDate: map['create_date'] != null ? DateTime.parse(map['create_date']) : null,
      lastSignInDate: map['last_signin_date'] != null ? DateTime.parse(map['last_signin_date']) : null,
      lastLoginInDate: map['last_login_date'] != null ? DateTime.parse(map['last_login_date']) : null,
    );
  }
}
