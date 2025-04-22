import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/utilities/enums/user_type.dart';

import '../../../model/campus.dart';
import '../../../model/post.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as GFUser;

class   FirebaseStoreService {
  FirebaseStoreService(this._store);
  final firebase_store.FirebaseFirestore _store;

  /// user Collection 생성 및 user 데이터 추가
  Future<Result<GFUser.User, Exception>> createUserDB(GFUser.User user) async {
    try {
      // User 컬렉션에 사용자 데이터 추가
      await _store.collection('User').doc(user.id).set(user.toMap());

      return Success(user);
    } catch (e) {
      return Failure(Exception('사용자 생성 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User, Exception>> getUserByPrviderUID(String providerUID) async {
    try {
      print('UserId: $providerUID');

      // simple_login_id가 userId와 일치하는 문서 쿼리
      final querySnapshot = await _store
          .collection('User')
          .where('simple_login_id', isEqualTo: providerUID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = GFUser.User.fromMap(querySnapshot.docs.first.data());
        return Success(userData);
      } else {
        return Failure(Exception(
            'firebase_store_service _getUserBySimpleLoginId error: 사용자를 찾을 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User?, Exception>> getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('User').doc(userId).get();

      if (docSnapshot.exists) {
        final userData = GFUser.User.fromMap(docSnapshot.data()!);

        return Success(userData);
      } else {
        return Success(null);
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// UserDB 삭제 함수
  Future<Result<void, Exception>> deleteUserDB(String userId) async {
    try {
      // Firestore에서 사용자 문서 삭제
      print('userId: $userId');
      await _store.collection('User').doc(userId).delete();
      return Success(null); // 성공적으로 삭제되었음을 나타냄
    } catch (e) {
      return Failure(Exception('사용자 데이터 삭제 실패: $e'));
    }
  }

  /// 외부 링크 추가
  Future<Result<String, Exception>> createExternalLink(GFUser.User user, String linkID, String linkDomainName) async {
    try {
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      var campusDocRef = _store.collection('Campus').doc(user.campus);

      // 링크를 단일 필드로 저장
      await campusDocRef.collection('ExternalLink').doc(linkID).set({'link': linkDomainName});

      return Success(linkDomainName);
    } catch (e) {
      print(e);
      return Failure(Exception('외부 링크 생성 실패: $e'));
    }
  }

  /// 외부 링크 가져오기
  Future<Result<String, Exception>> getExternalLink(GFUser.User user, String linkID) async {
    try {
      var campusDocRef = _store.collection('Campus').doc(user.campus);

      // 링크 문서 가져오기
      final docSnapshot = await campusDocRef.collection('ExternalLink').doc(linkID).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('link')) {
          return Success(data['link']);
        }
      }
      return Failure(Exception('링크를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('외부 링크 가져오기 실패: $e'));
    }
  }

  /// Campus 생성
  Future<Result<Campus, Exception>> createCampusDB(Campus campus) async {
    try {
      await _store
          .collection('Campus')
          .doc(campus.name)
          .collection('Information')
          .doc(campus.name)
          .set(campus.toMap());

      // 저장된 데이터를 다시 가져와 반환
      final documentSnapshot = await _store
          .collection('Campus')
          .doc(campus.name)
          .collection('Information')
          .doc(campus.id)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final savedCampus = Campus.fromMap(data);
          return Success(savedCampus);
        }
      }

      return Failure(Exception('저장된 캠퍼스 데이터를 찾을 수 없습니다.'));
    } catch (e) {
      print('err: $e');
      return Failure(Exception('캠퍼스 생성 실패: $e'));
    }
  }

  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    try {
      final documentSnapshot = await _store
          .collection('Campus')
          .doc(campusName)
          .collection('Information')
          .doc(campusName)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final savedCampus = Campus.fromMap(data);
          return Success(savedCampus);
        }
      }

      return Failure(Exception('저장된 캠퍼스 데이터를 찾을 수 없습니다.'));
    } catch (e) {
      print('err: $e');
      return Failure(Exception('캠퍼스 데이터 가져오기 실패: $e'));
    }
  }
  
}
