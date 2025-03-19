class User {
  String id;
  String simpleLoginProvider;
  String simpleLoginId;
  String userType;
  String campus;
  String course;
  String name;
  DateTime? createDate;
  DateTime? lastSignInDate;
  DateTime? lastLoginInDate;
  List<String> blockedUser;

  User({
    required this.id,
    required this.simpleLoginProvider,
    required this.simpleLoginId,
    this.userType = "student",
    required this.campus,
    required this.course,
    required this.name,
    this.createDate,
    this.lastSignInDate,
    this.lastLoginInDate,
    this.blockedUser = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'simple_login_provider': simpleLoginProvider,
      'simple_login_id': simpleLoginId,
      'user_type': userType,
      'campus': campus,
      'course': course,
      'name': name,
      'create_date': createDate?.toIso8601String(),
      'last_signin_date': lastSignInDate?.toIso8601String(),
      'last_login_date': lastSignInDate?.toIso8601String(),
      'blocked_user': blockedUser,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    // null 체크 및 기본값 설정
    String id = map['id'] ?? '';
    String simpleLoginProvider = map['simple_login_provider'] ?? '(익명)';
    String simpleLoginId = map['simple_login_id'] ?? '(익명)';
    String campus = map['campus'] ?? '(익명)';
    String course = map['course'] ?? '(익명)';
    String name = map['name'] ?? '(익명)';

    return User(
      id: id,
      simpleLoginProvider: simpleLoginProvider,
      simpleLoginId: simpleLoginId,
      userType: map['user_type'] ?? "student",
      campus: campus,
      course: course,
      name: name,
      createDate: map['create_date'] != null ? DateTime.parse(map['create_date']) : null,
      lastSignInDate: map['last_signin_date'] != null ? DateTime.parse(map['last_signin_date']) : null,
      lastLoginInDate: map['last_login_date'] != null ? DateTime.parse(map['last_login_date']) : null,
      blockedUser: List<String>.from(map['blocked_user'] ?? []),
    );
  }
}
