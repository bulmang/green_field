import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../cores/error_handler/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/token.dart';

part 'firebase_auth_service.g.dart';

class FirebaseAuthService {
  FirebaseAuthService(this._auth);
  final firebase_auth.FirebaseAuth _auth;

  Stream<firebase_auth.User?> authStateChanges() => _auth.authStateChanges();
  firebase_auth.User? get currentUser => _auth.currentUser;

  /// 현재 유저 Auth 가져오기
  Future<Result<firebase_auth.User, Exception>> getCurrentUser() async {
    try {
      // 현재 사용자 정보를 가져옵니다.
      final user = _auth.currentUser;

      if (user != null) {
        return Success(user); // 성공 시 User 객체 반환
      } else {
        return Failure(Exception('로그인이 필요합니다.')); // 로그인 필요 시 실패 반환
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 카카오 로그인 - Token 전달
  Future<Result<Token, Exception>> signInWithKakao() async {
    try {
      // 토큰 발급하기
      kakao.OAuthToken? token;
      token = await kakao.UserApi.instance.loginWithKakaoAccount();

      if (kIsWeb) {
        if (token != null) {
          final provider = 'oidc.kakaoweb';
          final idToken = token.idToken!; // idToken 언래핑
          final accessToken = token.accessToken;

          // Token 객체 생성
          final tokenObject = Token(
            provider: provider,
            idToken: idToken,
            accessToken: accessToken,
          );

          return Success(tokenObject);
        } else {
          return Failure(Exception('signInWithKakao Error'));
        }
      } else {
        if (token != null) {
          final provider = 'oidc.kakao';
          final idToken = token.idToken!; // idToken 언래핑
          final accessToken = token.accessToken;

          // Token 객체 생성
          final tokenObject = Token(
            provider: provider,
            idToken: idToken,
            accessToken: accessToken,
          );

          return Success(tokenObject);
        } else {
          return Failure(Exception('signInWithKakao Error'));
        }
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }

  /// 애플 로그인 - Token 전달
  Future<Result<Token, Exception>> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final firebase_auth.OAuthCredential credential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      if (credential.idToken != null && credential.accessToken != null) {
        final provider = credential.providerId;
        final idToken = credential.idToken!;
        final accessToken = credential.accessToken!;

        final tokenObject = Token(
          provider: provider,
          idToken: idToken,
          accessToken: accessToken,
        );

        return Success(tokenObject);
      } else {
        return Failure(Exception('signInWithApple Error'));
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }

  /// Firebase Auth 생성
  Future<Result<firebase_auth.User, Exception>> connectFirebaseAuth(String provider, String idToken, String accessToken) async {
    try {
      // OAuthCredential 생성
      final firebase_auth.OAuthCredential credential = firebase_auth.OAuthProvider(provider).credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Firebase에 자격 증명으로 로그인
      await _auth.signInWithCredential(credential);

      // 현재 로그인된 사용자 정보 가져오기
      firebase_auth.User? user = _auth.currentUser;

      if (user != null) {
        return Success(user);
      } else {
        return Failure(Exception('User 정보 가져오기 실패 에러 발생 Error'));
      }
    } catch (error) {
      return Failure(Exception(error));
    }
  }

  /// 회원 탈퇴 함수
  Future<Result<void, Exception>> deleteUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await user.delete(); // 현재 사용자 계정 삭제
        return Success(null); // 성공적으로 삭제되었음을 나타냄
      } else {
        return Failure(Exception('사용자가 로그인되어 있지 않습니다.'));
      }
    } catch (e) {
      return Failure(Exception('회원 탈퇴 실패: $e'));
    }
  }
}

// Riverpod provider 정의
@riverpod
FirebaseAuthService firebaseAuthService(Ref ref) {
  return FirebaseAuthService(firebase_auth.FirebaseAuth.instance);
}

@riverpod
FirebaseAuthService authRepository(Ref ref) {
  return FirebaseAuthService(ref.watch(firebaseAuthServiceProvider as ProviderListenable<firebase_auth.FirebaseAuth>));
}

@riverpod
Stream<firebase_auth.User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
