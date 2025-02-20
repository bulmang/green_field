import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:green_field/src/model/token.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
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

  Future<Result<void, Exception>> signOut() async {
    final result = await firebaseAuthService.signOut();

    switch (result) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<void, Exception>> deleteUser() async {
    final result = await firebaseAuthService.deleteUser();

    switch (result) {
      case Success(value: final v):
        return Success(v);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(firebaseAuthService: FirebaseAuthService(FirebaseAuth.instance));
});

