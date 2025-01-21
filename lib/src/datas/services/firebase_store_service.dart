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
        return Failure(Exception('firebase_store_service _getUserById error: 사용자를 찾을 수 없습니다.'));
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

  /// Notice Collection의 특정 Notice 데이터 업데이트
  Future<Result<Notice, Exception>> updateNoticeDB(Notice notice) async {
    print('updateNoticeDB service 실행');
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
      // 'notice' 컬렉션에서 상위 10개의 문서를 가져오는 쿼리
      final querySnapshot = await _store.collection('Notice')
          .orderBy('created_at', descending: true) // createdAt 필드로 정렬 (내림차순)
          .limit(10) // 상위 10개 문서만 가져오기
          .get();

      // 쿼리 결과에서 Notice 객체 리스트 생성
      List<Notice> noticeList = querySnapshot.docs.map((doc) =>
          Notice.fromMap(doc.data())).toList();
      if (noticeList != []) {
        return Success(noticeList);
      } else {
        return Success([Notice(id: '', creatorId: '', userCampus: '관리자', title: '공지사항이 없습니다.', body: '공지사항을 등록해주세요.', like: [], createdAt: DateTime.now())]);
      }
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }

}