import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import '../../model/notice.dart';
import '../../model/user.dart' as GFUser;

class FirebaseStoreService {
  FirebaseStoreService(this._store);
  final firebase_store.FirebaseFirestore _store;

  /// user Collection 생성 및 user 데이터 추가
  Future<Result<GFUser.User, Exception>> createUserDB(GFUser.User user) async {
    try {
      // User 컬렉션에 사용자 데이터 추가
      await _store.collection('user').doc(user.id).set(user.toMap());

      return Success(user);
    } catch (e) {
      return Failure(Exception('사용자 생성 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User, Exception>> getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('user').doc(userId).get();

      if (docSnapshot.exists) {
        final userData = GFUser.User.fromMap(docSnapshot.data()!);
        return Success(userData);
      } else {
        return Failure(Exception(
            'firebase_store_service _getUserById error: 사용자를 찾을 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// Notice Collection 생성 및 Notice 데이터 추가
  Future<Result<Notice, Exception>> createNoticeDB(Notice notice) async {
    print('createNoticeDB service 실행');
    try {
      await _store.collection('Notice').doc(notice.id).set(notice.toMap());

      return Success(notice);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 생성 실패: $e'));
    }
  }

  /// Notice Collection에서 Notice 데이터 삭제
  Future<Result<void, Exception>> deleteNoticeDB(String noticeId) async {
    try {
      await _store.collection('Notice').doc(noticeId).delete();

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 삭제 실패: $e'));
    }
  }

  /// Notice Collection의 특정 Notice 데이터 업데이트
  Future<Result<Notice, Exception>> updateNoticeDB(Notice notice) async {
    try {
      // Firestore에서 해당 문서 업데이트
      await _store.collection('Notice').doc(notice.id).update(notice.toMap());

      return Success(notice);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 업데이트 실패: $e'));
    }
  }

  /// Notice List 가져오기
  Future<Result<List<Notice>, Exception>> getNoticeList() async {
    try {
      // 기본 쿼리
      var query = _store
          .collection('Notice')
          .orderBy('created_at', descending: true)
          .limit(10);


      // 첫 번째 페이지 또는 페이징 데이터를 가져오기
      var querySnapshot = await query.get();

      // 데이터를 Notice 객체로 매핑
      List<Notice> noticeList = querySnapshot.docs
          .map((doc) => Notice.fromMap(doc.data()))
          .toList();

      if (noticeList.isEmpty) {
        return Success([]);
      } else {
        return Success(noticeList);
      }
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }

  /// Notice List 추가로 가져오기
  Future<Result<List<Notice>, Exception>> getNextNoticeList(List<Notice>? lastNotice) async {
    try {

      var query = _store
          .collection('Notice')
          .orderBy('created_at', descending: true)
          .limit(10);

      if (lastNotice != null) {
        final lastDoc = await _store.collection('Notice')
            .doc(lastNotice.last.id)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      var querySnapshot = await query.get();

      List<Notice> noticeList = querySnapshot.docs
          .map((doc) => Notice.fromMap(doc.data()))
          .toList();

      if (noticeList.isEmpty) {
        return Success([]);
      } else {
        if (lastNotice != null)
          lastNotice!.addAll(noticeList);

        return Success(lastNotice ?? noticeList);
      }
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }
}
