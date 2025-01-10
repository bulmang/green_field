import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:green_field/src/cores/error_handler/result.dart';
import '../../model/user.dart' as GFUser;


class FirebaseStoreService {
  FirebaseStoreService(this._store);
  final firebase_store.FirebaseFirestore _store;

  /// user Collection 생성 및 user 데이터 추가
  Future<Result<GFUser.User, Exception>> createUserDB(GFUser.User user) async {
    try {
      // User 컬렉션에 사용자 데이터 추가
      await _store.collection('user').doc(user.id).set(user.toMap());

      print('user.id : ${user.id}');
      // 사용자 ID로 사용자 정보를 가져옴
      final result = await _getUserById(user.id);

      // 결과를 처리
      return switch (result) {
        Success(value: final user) => Success(user),
        Failure(exception: final e) => Failure(e),
      };

    } catch (e) {
      return Failure(Exception('사용자 생성 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User, Exception>> _getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('users').doc(userId).get();

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
}