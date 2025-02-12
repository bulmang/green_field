
enum UserType {
  manager,
  master,
  student,
  careerCoach,
}

String getUserTypeName(UserType userType) {
  switch (userType) {
    case UserType.manager:
      return 'manager';
    case UserType.master:
      return 'master';
    case UserType.student:
      return 'student';
    case UserType.careerCoach:
      return 'careerCoach';
    default:
      return 'unknown';
  }
}
