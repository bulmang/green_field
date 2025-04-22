import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/onboarding_service_interface.dart';
import '../../../model/user.dart' as Client;

class FirebaseStoreOnboardingService implements OnboardingServiceInterface {
  FirebaseStoreOnboardingService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<Client.User, Exception>> createUserDB(Client.User user) async {
    try {
      await _store.collection('User').doc(user.id).set(user.toMap());
      return Success(user);
    } catch (e) {
      return Failure(Exception('사용자 생성 실패: $e'));
    }
  }

  @override
  Future<Result<Client.User, Exception>> getUserByProviderUID(String providerUID) async {
    try {
      final querySnapshot = await _store
          .collection('User')
          .where('simple_login_id', isEqualTo: providerUID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = Client.User.fromMap(querySnapshot.docs.first.data());
        return Success(userData);
      } else {
        return Failure(Exception('firebase_store_service _getUserBySimpleLoginId error: 사용자를 찾을 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<Client.User?, Exception>> getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('User').doc(userId).get();

      if (docSnapshot.exists) {
        final userData = Client.User.fromMap(docSnapshot.data()!);
        return Success(userData);
      } else {
        return Success(null);
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

}
