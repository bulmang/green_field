import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/recruit_service_interface.dart';
import '../../../model/recruit.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as Client;

class FirebaseStoreRecruitService implements RecruitServiceInterface {
  FirebaseStoreRecruitService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<List<Recruit>, Exception>> getRecruitList() async {
    try {
      final query = _store
          .collection('Recruit')
          .orderBy('remain_time')
          .limit(10);

      final querySnapshot = await query.get();

      final recruitList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        return Recruit.fromMap({
          ...data,
          'id': doc.id,
        });
      }));

      return Success(recruitList.isEmpty ? [] : recruitList);
    } catch (e) {
      return Failure(Exception('RecruitList 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> createRecruitDB(Recruit recruit, Client.User user) async {
    try {
      await _store.collection('Recruit').doc(recruit.id).set(recruit.toMap());
      return Success(recruit);
    } catch (e) {
      return Failure(Exception('recruit 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> createDeadRecruitDB(Recruit recruit) async {
    try {
      await _store.collection('DeadRecruit').doc(recruit.id).set(recruit.toMap());
      await moveAndDeleteCollection(recruit.id);
      await _store.collection('Recruit').doc(recruit.id).delete();
      return Success(recruit);
    } catch (e) {
      return Failure(Exception('recruit 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> moveAndDeleteCollection(String recruitId) async {
    try {
      final querySnapshot = await _store
          .collection('Recruit')
          .doc(recruitId)
          .collection('Message')
          .get();

      final batch = _store.batch();
      for (final doc in querySnapshot.docs) {
        batch.set(
          _store.collection('DeadRecruit').doc(recruitId).collection('Message').doc(doc.id),
          doc.data(),
        );
      }
      await batch.commit();

      final deleteBatch = _store.batch();
      for (final doc in querySnapshot.docs) {
        deleteBatch.delete(doc.reference);
      }
      await deleteBatch.commit();

      return Success(null);
    } catch (e) {
      return Failure(Exception('데이터 이동 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> getRecruit(String recruitId, Client.User user) async {
    try {
      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          return Success(Recruit.fromMap({
            ...data,
            'id': documentSnapshot.id,
          }));
        }
      }
      return Failure(Exception('데이터가 존재하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('모집 데이터 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> entryRecruitRoom(String recruitId, String userId) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'current_participants': firebase_store.FieldValue.arrayUnion([userId]),
      });

      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();
      return _handleDocumentSnapshot(documentSnapshot);
    } catch (e) {
      return Failure(Exception('채팅방 입장 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> outRecruitRoom(String recruitId, String userId) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'current_participants': firebase_store.FieldValue.arrayRemove([userId]),
      });

      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();
      return _handleDocumentSnapshot(documentSnapshot);
    } catch (e) {
      return Failure(Exception('채팅방 퇴장 실패: $e'));
    }
  }

  @override
  Future<Result<Recruit, Exception>> reportRecruit(
      String recruitId,
      String userId,
      String reason
      ) async {
    try {
      await _store.collection('Recruit').doc(recruitId).update({
        'reported_users': firebase_store.FieldValue.arrayUnion([userId]),
      });

      final documentSnapshot = await _store.collection('Recruit').doc(recruitId).get();
      return _handleDocumentSnapshot(documentSnapshot);
    } catch (e) {
      return Failure(Exception('신고 기능 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report) async {
    try {
      await _store.collection('Report').doc('Recruit').collection(report.id).doc(report.type).set(report.toMap());
      return Success(null);
    } catch (e) {
      return Failure(Exception('신고 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> deleteRecruitDB(String recruitId, Client.User user) async {
    try {
      await _store.collection('Recruit').doc(recruitId).delete();
      await moveAndDeleteCollection(recruitId);
      return Success(null);
    } catch (e) {
      return Failure(Exception('모집글 삭제 실패: $e'));
    }
  }

  // 공통 문서 처리 헬퍼 메서드
  Result<Recruit, Exception> _handleDocumentSnapshot(
      firebase_store.DocumentSnapshot documentSnapshot
      ) {
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null) {
        return Success(Recruit.fromMap({
          ...data as Map<String, dynamic>,
          'id': documentSnapshot.id,
        }));
      }
    }
    return Failure(Exception('모집글을 찾을 수 없습니다.'));
  }
}
