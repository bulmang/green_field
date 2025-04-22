import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/setting_service_interface.dart';
import '../../../model/user.dart' as Client;
import '../../../utilities/enums/user_type.dart';

class FirebaseStoreSettingService implements SettingServiceInterface {
  FirebaseStoreSettingService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<void, Exception>> deleteUserDB(String userId) async {
    try {
      await _store.collection('User').doc(userId).delete();
      return Success(null);
    } catch (e) {
      return Failure(Exception('사용자 데이터 삭제 실패: $e'));
    }
  }

  @override
  Future<Result<String, Exception>> createExternalLink(
      Client.User user,
      String linkID,
      String linkDomainName
      ) async {
    try {
      if (user.campus == '익명' ||
          user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      final campus = user.campus ?? '관악';
      await _store
          .collection('Campus')
          .doc(campus)
          .collection('ExternalLink')
          .doc(linkID)
          .set({'link': linkDomainName});

      return Success(linkDomainName);
    } catch (e) {
      return Failure(Exception('외부 링크 생성 실패: $e'));
    }
  }

  @override
  Future<Result<String, Exception>> getExternalLink(
      Client.User user,
      String linkID
      ) async {
    try {
      final campus = user.campus ?? '관악';
      final docSnapshot = await _store
          .collection('Campus')
          .doc(campus)
          .collection('ExternalLink')
          .doc(linkID)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('link')) {
          return Success(data['link'] as String);
        }
      }
      return Failure(Exception('$linkID 링크를 찾을 수 없습니다.'));
    } catch (e) {
      return Failure(Exception('외부 링크 조회 실패: $e'));
    }
  }
}
