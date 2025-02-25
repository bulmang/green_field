import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';

import '../../cores/error_handler/result.dart';
import '../services/firebase_store_service.dart';
import '../../model/user.dart' as GFUser;

class SettingRepository {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseStoreService firebaseStoreService;

  SettingRepository({required this.firebaseAuthService, required this.firebaseStoreService});

  Future<Result<void, Exception>> signOut() async {
    final result = await firebaseAuthService.signOut();

    switch (result) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<void, Exception>> deleteUser(String userId) async {
    final result = await firebaseStoreService.deleteUserDB(userId);

    switch (result) {
      case Success(value: final v):
        return await resetUser();
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<void, Exception>> resetUser() async {
    final resetUser = await firebaseAuthService.resetCurrentUser();
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<String, Exception>> createExternalLink(GFUser.User user, String linkID, String linkDomainName) async {
    final resetUser = await firebaseStoreService.createExternalLink(user, linkID, linkDomainName);
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  Future<Result<String, Exception>> getExternalLink(GFUser.User user, String linkID) async {
    final resetUser = await firebaseStoreService.getExternalLink(user, linkID);
    switch (resetUser) {
      case Success(value: final value):
        return Success(value);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}

final settingRepositoryProvider = Provider<SettingRepository>((ref) {
  return SettingRepository(firebaseAuthService: FirebaseAuthService(FirebaseAuth.instance), firebaseStoreService: FirebaseStoreService(FirebaseFirestore.instance));
});

