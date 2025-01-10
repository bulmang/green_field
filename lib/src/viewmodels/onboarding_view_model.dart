import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:green_field/src/datas/repositories/onboarding_repository.dart';
import 'package:green_field/src/viewmodels/login_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../cores/error_handler/result.dart';
import '../datas/services/firebase_auth_service.dart';
import '../model/user.dart' as myUser; // User 모델 import

part 'onboarding_view_model.g.dart'; // 생성된 코드를 위한 파일

@Riverpod(keepAlive: true)
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  Future<void> build() async {}
  myUser.User? currentUser; // Firebase User 정보를 담을 변수

  /// Auth User 생성
  Future<Result<firebase_auth.User, Exception>> createAuthUser(String provider, String idToken, String accessToken) async {
    state = AsyncLoading();
    final result = await ref
        .read(onboardingRepositoryProvider)
        .createAuthUser(provider, idToken, accessToken);

    switch (result) {
      case Success(value: final authUser):
        _createUserModel();
        return Success(authUser);
      case Failure(exception: final e):
        return Failure(e);
    }
  }

  /// User DB 생성
  Future<Result<myUser.User, Exception>> _createUserDB(myUser.User user) async {
    final authRepository = ref.read(firebaseAuthServiceProvider);
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser != null && firebaseUser.providerData.isNotEmpty) {
      final result = await ref
          .read(onboardingRepositoryProvider)
          .createUserDB(user);

      switch (result) {
        case Success(value: final user):
          return Success(user);
        case Failure(exception: final e):
          return Failure(e);
      }
    } else {
      return Failure(Exception('사용자가 로그인되어 있지 않거나 제공자 데이터가 없습니다.'));
    }
  }

  /// User Model 객체 생성
  Future<Result<myUser.User, Exception>> _createUserModel() async {
    final authRepository = ref.read(firebaseAuthServiceProvider);
    final firebaseUser = authRepository.currentUser;
    final course = ref.read(courseTextFieldProvider);
    final campus = ref.read(campusProvider);

    if (firebaseUser != null && firebaseUser.providerData != null) {
      final userProviderData = firebaseUser!.providerData.isNotEmpty
          ? firebaseUser.providerData[0]
          : null;

      currentUser = myUser.User(
        id: firebaseUser.uid,
        providerId: userProviderData!.providerId,
        userType: 'student', // TODO: 추후 manager type 추가.
        campus: campus,
        course: course,
        name: firebaseUser.displayName ?? '(empty)',
        createDate: firebaseUser.metadata.creationTime,
        lastSignInDate: firebaseUser.metadata.lastSignInTime,
        lastLoginInDate: firebaseUser.metadata.lastSignInTime,
      );

      final result = await _createUserDB(currentUser!);

      switch (result) {
        case Success(value: final myUser.User user):
          return Success(user);
        case Failure(exception: final exception):
          return Failure(Exception(exception));
      }
    } else {
      return Failure(Exception('firebaseUser가 없습니다.'));
    }
  }
}

/// courseProvider 생성
final courseTextFieldProvider =
    StateNotifierProvider<CourseNotifier, String>(
  (ref) => CourseNotifier(),
);

class CourseNotifier extends StateNotifier<String> {
  CourseNotifier() : super(''); // 초기 상태 설정

  void setKeyword(String inputText) {
    state = inputText;
  }
}

/// campusProvider 생성
final campusProvider = StateNotifierProvider<CampusNotifier, String>(
  (ref) => CampusNotifier(),
);

class CampusNotifier extends StateNotifier<String> {
  CampusNotifier() : super('---');

  void updateSelectedCampus(String campus) {
    state = campus;
  }
}
