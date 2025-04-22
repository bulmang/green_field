import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:green_field/src/domains/interfaces/onboarding_service_interface.dart';
import '../../cores/error_handler/result.dart';
import '../../model/token.dart';
import '../../model/user.dart' as Client;
import '../services/firebase_stores/firebase_store_service.dart';

class OnboardingRepository {
  final FirebaseAuthService firebaseAuthService;
  final OnboardingServiceInterface store;

  OnboardingRepository({required this.firebaseAuthService, required this.store});

  /// 사용자 인증 생성 (신규 유저)
  Future<Result<firebase_auth.User, Exception>> createAuthUser(String provider, String idToken, String accessToken, String providerUID) async {
    try {
      final result = await firebaseAuthService.connectFirebaseAuth(provider, idToken, accessToken, providerUID);

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

  /// 사용자 인증 생성 (기존 유저)
  Future<Result<void, Exception>> isExistUserCreateAuth(Token token) async {
    try {
      final result = await firebaseAuthService.isExistUserConnectFirebaseAuth(token);

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

  /// 사용자 데이터 생성
  Future<Result<Client.User, Exception>> createUserDB(Client.User user) async {
    try {
      final result = await store.createUserDB(user);

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

  /// 사용자 데이터 호출
  Future<Result<Client.User, Exception>> getUser(providerUID) async {
    try {
      final result = await store.getUserByProviderUID(providerUID);

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

  /// 사용자 인증 호출
  Future<Result<Client.User?, Exception>> getAuthUser() async {
    try {
      final result = await firebaseAuthService.getCurrentUser();

      switch (result) {
        case Success(value: final authUser):
          final getUserDB = await store.getUserById(authUser.uid);
          switch (getUserDB) {
            case Success(value: final userDB):
              return Success(userDB);
            case Failure(exception: final exception):
              return Failure(exception);
          }
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
      store: FirebaseStoreOnboardingService(firebase_store.FirebaseFirestore.instance),
  );
});
