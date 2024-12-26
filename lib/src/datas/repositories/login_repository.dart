import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:green_field/src/viewmodels/user_view_model.dart';

import '../../cores/error_handler/result.dart';
import '../../model/user.dart';

class LoginRepository {
  final _firebaseAuthService = FirebaseAuthService();

  Future<Result<User, Exception>> signInWithKakao() async {
    final result = await _firebaseAuthService.signInWithKakao();

    switch (result) {
      case Success(value: final authUser):
        return Success(_createUserFromAuth(authUser));
      case Failure(exception: final exception):
        return Failure(exception);
      default:
        throw Exception('Unexpected result type');
    }
  }

  User _createUserFromAuth(authUser) {
    Map<String, dynamic> data = {
      'id': authUser.uid,
      'simple_login_id': authUser.providerData.isNotEmpty ? authUser.providerData.first.providerId : 'unknown',
      'user_type': '카카오',
      'campus': '관악',
      'course': 'Flutter',
      'name': '하명관',
      'create_date': authUser.metadata.creationTime?.toIso8601String(),
      'last_login_date': authUser.metadata.lastSignInTime?.toIso8601String(),
    };

    return User.fromMap(data);
  }
}
