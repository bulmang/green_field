import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../cores/error_handler/result.dart';
import '../../model/user.dart' as myUser;
import '../services/firebase_stores/firebase_store_service.dart';

class HomeRepository {
  final FirebaseAuthService firebaseAuthService;

  HomeRepository({required this.firebaseAuthService});

}

/// HomeRepositoryProvider 생성
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
      firebaseAuthService: FirebaseAuthService(firebase_auth.FirebaseAuth.instance),
  );
});
