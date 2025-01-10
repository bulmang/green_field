import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../cores/error_handler/result.dart';
import '../../model/user.dart' as myUser;
import '../services/firebase_store_service.dart';

class OnboardingRepository {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseStoreService firebaseStoreService;

  OnboardingRepository({required this.firebaseAuthService, required this.firebaseStoreService});

  // Auth User 생성
  Future<Result<firebase_auth.User, Exception>> createAuthUser(String provider, String idToken, String accessToken) async {
    try {
      final result = await firebaseAuthService.connectFirebaseAuth(provider, idToken, accessToken);

      switch (result) {
        case Success(value: final authUser):
          return Success(authUser);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }

  /// User DB 생성
  Future<Result<myUser.User, Exception>> createUserDB(myUser.User user) async {
    try {
      final result = await firebaseStoreService.createUserDB(user);

      switch (result) {
        case Success(value: final authUser):
          return Success(authUser);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// User DB 호출
  Future<Result<myUser.User, Exception>> getUser(userId) async {
    try {
      final result = await firebaseStoreService.getUserById(userId);

      switch (result) {
        case Success(value: final authUser):
          return Success(authUser);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }
}

/// OnboardingRepositoryProvider 생성
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(
      firebaseAuthService: FirebaseAuthService(firebase_auth.FirebaseAuth.instance),
      firebaseStoreService: FirebaseStoreService(firebase_store.FirebaseFirestore.instance),
  );
});
