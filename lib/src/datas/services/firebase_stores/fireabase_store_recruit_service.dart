import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../model/recruit.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as GFUser;

class FirebaseStoreRecruitService {
  FirebaseStoreRecruitService(this._store);

  final firebase_store.FirebaseFirestore _store;

  /// Recruit List 가져오기
  Future<Result<List<Recruit>, Exception>> getRecruitList() async {
    try {
      var query = _store
          .collection('Recruit')
          .orderBy('remain_time')
          .limit(10);

      var querySnapshot = await query.get();

      // 데이터를 Post 객체로 매핑
      List<Recruit> recruitList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        return Recruit.fromMap({
          ...data,
          'id': doc.id,
        });
      }));

      print('rrewrwersfdsfsdf: ${recruitList.toString()}');
      if (recruitList.isEmpty) {
        return Success([]);
      } else {
        return Success(recruitList);
      }
    } catch (e) {
      return Failure(Exception('RecruitList 가져오기 실패: $e'));
    }
  }

  /// Recruit Collection 생성 및 Recruit 데이터 추가
  Future<Result<Recruit, Exception>> createRecruitDB(Recruit recruit, GFUser.User user) async {
    try {
      await _store.collection('Recruit').doc(recruit.id).set(recruit.toMap());

      return Success(recruit);
    } catch (e) {
      print(e);
      return Failure(Exception('recruit 데이터 생성 실패: $e'));
    }
  }

  /// DeadRecruit Collection 생성 및 DeadRecruit 데이터 추가
  Future<Result<Recruit, Exception>> createDeadRecruitDB(Recruit recruit) async {
    try {
      await _store.collection('DeadRecruit').doc(recruit.id).set(recruit.toMap());
      await moveAndDeleteCollection(recruit.id);
      await _store.collection('Recruit').doc(recruit.id).delete();

      return Success(recruit);
    } catch (e) {
      print(e);
      return Failure(Exception('recruit 데이터 생성 실패: $e'));
    }
  }

  Future<void> moveAndDeleteCollection(String recruitId) async {
    // 기존 문서를 가져옵니다.
    final querySnapshot = await _store
        .collection('Recruit')
        .doc(recruitId)
        .collection('Message')
        .get();

    final batch = _store.batch();

    querySnapshot.docs.forEach((doc) {
      batch.set(
        _store
            .collection('DeadRecruit')
            .doc(recruitId)
            .collection('Message')
            .doc(doc.id),
        doc.data(),
      );
    });

    await batch.commit();

    final deleteBatch = _store.batch();
    querySnapshot.docs.forEach((doc) {
      deleteBatch.delete(doc.reference);
    });
    await deleteBatch.commit();
  }

  /// 특정 Recruit 가져오기
  Future<Result<Recruit, Exception>> getRecruit(String recruitId, GFUser.User user) async {
    try {
      print('postId $recruitId');
      // Firestore에서 특정 문서 가져오기
      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Post 객체로 변환
          final post = Recruit.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(post);
        }
      }
      return Failure(Exception('데이터가 존재 하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('모집 데이터 가져오기 실패: $e'));
    }
  }

  /// 특정 Recruit Chat에 입장한 유저 추가
  Future<Result<Recruit, Exception>> entryChatRoom(String recruitId, String userId) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'current_participants': firebase_store.FieldValue.arrayUnion([userId]),
      });

      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final recruit = Recruit.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(recruit);
        }
      }
      return Failure(Exception('모집글를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('신고 기능 실패: $e'));
    }
  }

  /// 특정 Recruit Chat에 퇴장한 유저 추가
  Future<Result<Recruit, Exception>> outChatRoom(String recruitId, String userId) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'current_participants': firebase_store.FieldValue.arrayRemove([userId]),
      });

      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final recruit = Recruit.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(recruit);
        }
      }
      return Failure(Exception('모집글를 찾을 수 없습니다.'));
    } catch (e) {
      return Failure(Exception('채팅방 나가기 실패: $e'));
    }
  }

  /// 특정 Recruit에 신고한 유저들 추가
  Future<Result<Recruit, Exception>> reportRecruit(String recruitId, String userId, String reason) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'reported_users': firebase_store.FieldValue.arrayUnion([userId]),
      });

      // 업데이트된 Post 문서 가져오기
      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final recruit = Recruit.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(recruit);
        }
      }
      return Failure(Exception('모집글를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('신고 기능 실패: $e'));
    }
  }

  /// Recruit 신고 데이터 생성
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report) async {
    try {
      await _store.collection('Report').doc('Recruit').collection(report.id).doc(report.type).set(report.toMap());

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 생성 실패: $e'));
    }
  }

  /// Recruit 데이터 삭제
  Future<Result<void, Exception>> deleteRecruitDB(String recruitId, GFUser.User user) async {
    try {
      await _store.collection('Recruit').doc(recruitId).delete();

      return Success(null);
    } catch (e) {
      return Failure(Exception('post 데이터 삭제 실패: $e'));
    }
  }
}