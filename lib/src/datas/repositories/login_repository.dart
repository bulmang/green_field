import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:green_field/src/model/token.dart';
import '../../cores/error_handler/result.dart';

class LoginRepository {
  final FirebaseAuthService firebaseAuthService;

  LoginRepository({required this.firebaseAuthService});

  Future<Result<Token, Exception>> signInWithKakao() async {
    final result = await firebaseAuthService.signInWithKakao();

    switch (result) {
      case Success(value: final token):
        return Success(token);
      case Failure(exception: final exception):
        return Failure(exception);
      default:
        throw Exception('Unexpected result type');
    }
  }

  Future<Result<Token, Exception>> signInWithApple() async {
    final result = await firebaseAuthService.signInWithApple();

    switch (result) {
      case Success(value: final token):
        return Success(token);
      case Failure(exception: final exception):
        return Failure(exception);
      default:
        throw Exception('Unexpected result type');
    }
  }

  Future<Result<firebase_auth.User, Exception>> signInWithAnonymously() async {
    final result = await firebaseAuthService.signInAnonymously();

    switch (result) {
      case Success(value: final v):
        return Success(v);
      case Failure(exception: final exception):
        return Failure(exception);
      default:
        throw Exception('Unexpected result type');
    }
  }

}

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(firebaseAuthService: FirebaseAuthService(firebase_auth.FirebaseAuth.instance));
});

