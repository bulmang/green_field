import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:green_field/src/domains/interfaces/setting_service_interface.dart';

import '../../cores/error_handler/result.dart';
import '../../model/user.dart' as Client;
import '../services/firebase_stores/firebase_store_setting_service.dart';

class SettingRepository {
  final FirebaseAuthService firebaseAuthService;
  final SettingServiceInterface store;

  SettingRepository({required this.firebaseAuthService, required this.store});

  /// 사용자 로그 아웃
  Future<Result<void, Exception>> signOut() async {
    final result = await firebaseAuthService.signOut();

    switch (result) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  /// 사용자 데이터 삭제
  Future<Result<void, Exception>> deleteUser(String userId) async {
    final result = await store.deleteUserDB(userId);

    switch (result) {
      case Success(value: final v):
        return await resetUser();
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  /// 사용자 데이터 초기화
  Future<Result<void, Exception>> resetUser() async {
    final resetUser = await firebaseAuthService.resetCurrentUser();
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  /// 외부 링크 생성 (관리자 전용)
  Future<Result<String, Exception>> createExternalLink(Client.User user, String linkID, String linkDomainName) async {
    final resetUser = await store.createExternalLink(user, linkID, linkDomainName);
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  /// 외부 링크 조회
  Future<Result<String, Exception>> getExternalLink(Client.User user, String linkID) async {
    final resetUser = await store.getExternalLink(user, linkID);
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}

final settingRepositoryProvider = Provider<SettingRepository>((ref) {
  return SettingRepository(
      firebaseAuthService: FirebaseAuthService(FirebaseAuth.instance),
      store: FirebaseStoreSettingService(FirebaseFirestore.instance),
  );
});

