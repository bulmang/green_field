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

  Future<Result<void, Exception>> resetCurrentUser() async {
    try {
      await _auth.signOut();
      return Success(null);
    } catch (e) {
      return Failure(Exception('사용자 초기화 실패: $e'));
    }
  }

  /// 카카오 로그인 - Token 전달
  Future<Result<Token, Exception>> signInWithKakao() async {
    try {
      // 토큰 발급하기
      kakao.OAuthToken? token;
      token = await kakao.UserApi.instance.loginWithKakaoAccount();

      // 카카오 계정 정보 가져오기
      kakao.User user = await kakao.UserApi.instance.me();
      final String userId = user.id.toString(); // 변하지 않는 고유 ID

      if (kIsWeb) {
        if (token != null) {
          final provider = 'oidc.kakaoweb';
          final idToken = token.idToken ?? ''; // idToken 언래핑
          final accessToken = token.accessToken;

          // Token 객체 생성
          final tokenObject = Token(
              provider: provider,
              idToken: idToken,
              accessToken: accessToken,
              providerUID: userId
          );

          print('카카오 ID: ${tokenObject.providerUID}');

          return Success(tokenObject);
        } else {
          return Failure(Exception('signInWithKakao Error'));
        }
      } else {
        if (token != null) {
          final provider = 'oidc.kakao';
          final idToken = token.idToken ?? ''; // idToken 언래핑
          final accessToken = token.accessToken;

          // Token 객체 생성
          final tokenObject = Token(
            provider: provider,
            idToken: idToken,
            accessToken: accessToken,
            providerUID: userId
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
        final providerUID = appleCredential.userIdentifier!;

        final tokenObject = Token(
          provider: provider,
          idToken: idToken,
          accessToken: accessToken,
          providerUID: providerUID,
        );

        return Success(tokenObject);
      } else {
        return Failure(Exception('signInWithApple Error'));
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }

  /// 익명 로그인 함수
  Future<Result<firebase_auth.User, Exception>> signInAnonymously() async {
    try {
      // Firebase에 익명으로 로그인
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        return Success(user); // 성공 시 User 객체 반환
      } else {
        return Failure(Exception('익명 로그인 실패: 사용자 정보를 가져올 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('익명 로그인 실패: $e'));
    }
  }

  /// Firebase Auth 생성
  Future<Result<firebase_auth.User, Exception>> connectFirebaseAuth(String provider, String idToken, String accessToken, String providerUID) async {
    try {
      // OAuthCredential 생성
      final firebase_auth.OAuthCredential credential = firebase_auth.OAuthProvider(provider).credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      print('파이어베이스 ID: ${credential.idToken}');

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
      print('error: $error');
      return Failure(Exception(error));
    }
  }

  /// Firebase Auth 생성
  Future<Result<void, Exception>> isExistUserConnectFirebaseAuth(Token token) async {
    try {
      if (token == null) {
        return Failure(Exception('토큰이 없습니다.')); // 토큰이 null일 경우 실패 반환
      }

      final firebase_auth.OAuthCredential credential = firebase_auth.OAuthProvider(token.provider).credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      print('파이어베이스 ID: ${credential.idToken}');

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
      print('error: $error');
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

  /// 로그아웃 함수
  Future<Result<void, Exception>> signOut() async {
    try {
      await _auth.signOut();
      return Success(null);
    } catch (e) {
      return Failure(Exception('로그아웃 실패: $e'));
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
