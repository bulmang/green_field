import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/notice_service_interface.dart';
import '../../../model/notice.dart';
import '../../../model/user.dart' as Client;
import '../../../utilities/enums/user_type.dart';


class FirebaseStoreNoticeService implements NoticeServiceInterface {
  FirebaseStoreNoticeService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<Notice, Exception>> createNoticeDB(Notice notice, Client.User user) async {
    try {
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      final campus = user.campus;
      await _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .doc(notice.id)
          .set(notice.toMap());

      return Success(notice);
    } catch (e) {
      return Failure(Exception('notice 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> deleteNoticeDB(String noticeId, Client.User user) async {
    try {
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      final campus = user.campus;
      await _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .doc(noticeId)
          .delete();

      return Success(null);
    } catch (e) {
      return Failure(Exception('notice 데이터 삭제 실패: $e'));
    }
  }

  @override
  Future<Result<Notice, Exception>> updateNoticeDB(Notice notice, Client.User user) async {
    try {
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      final campus = user.campus;
      await _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .doc(notice.id)
          .update(notice.toMap());

      return Success(notice);
    } catch (e) {
      return Failure(Exception('notice 데이터 업데이트 실패: $e'));
    }
  }

  @override
  Future<Result<List<Notice>, Exception>> getNoticeList(Client.User? user) async {
    try {
      final campus = user?.campus == '익명' ? '관악' : user!.campus;
      final query = _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .orderBy('created_at', descending: true)
          .limit(15);

      final querySnapshot = await query.get();
      final noticeList = querySnapshot.docs
          .map((doc) => Notice.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      return Success(noticeList);
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<List<Notice>, Exception>> getNextNoticeList(
      List<Notice>? lastNotice,
      Client.User user
      ) async {
    try {
      final campus = user.campus == '익명' ? '관악' : user.campus;
      var query = _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .orderBy('created_at', descending: true)
          .limit(10);

      if (lastNotice != null && lastNotice.isNotEmpty) {
        final lastDoc = await _store
            .collection('Campus')
            .doc(campus)
            .collection('Notice')
            .doc(lastNotice.last.id)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      final newNotices = querySnapshot.docs
          .map((doc) => Notice.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      return Success([...lastNotice ?? [], ...newNotices]);
    } catch (e) {
      return Failure(Exception('getNextNoticeList 함수 에러: $e'));
    }
  }

  @override
  Future<Result<Notice, Exception>> getNotice(String noticeId, Client.User user) async {
    try {
      final campus = user.campus == '익명' ? '관악' : user.campus;
      final docSnapshot = await _store
          .collection('Campus')
          .doc(campus)
          .collection('Notice')
          .doc(noticeId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return Success(Notice.fromMap({...data, 'id': docSnapshot.id}));
        }
      }
      return Failure(Exception('데이터가 존재하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }
}
