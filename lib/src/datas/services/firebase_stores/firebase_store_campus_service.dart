import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/campus_service_interface.dart';
import '../../../model/campus.dart';

class FirebaseStoreCampusService implements CampusServiceInterface {
  FirebaseStoreCampusService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<Campus, Exception>> createCampusDB(Campus campus) async {
    try {
      final campusRef = _store
          .collection('Campus')
          .doc(campus.name)
          .collection('Information')
          .doc(campus.name);

      await campusRef.set(campus.toMap());

      final snapshot = await campusRef.get();
      if (snapshot.exists) {
        return Success(Campus.fromMap(snapshot.data()!));
      }
      return Failure(Exception('생성된 캠퍼스 데이터를 찾을 수 없습니다.'));
    } catch (e) {
      return Failure(Exception('캠퍼스 생성 실패: $e'));
    }
  }

  @override
  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    try {
      final snapshot = await _store
          .collection('Campus')
          .doc(campusName)
          .collection('Information')
          .doc(campusName)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return Success(Campus.fromMap(snapshot.data()!));
      }
      return Failure(Exception('$campusName 캠퍼스가 존재하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('캠퍼스 조회 실패: $e'));
    }
  }
}
