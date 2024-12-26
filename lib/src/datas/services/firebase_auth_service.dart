import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../cores/error_handler/result.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService():_auth=FirebaseAuth.instance{
    _auth.setLanguageCode('kr');
  }

  /// 카카오 로그인 - Firebase Auth User 전달
  Future<Result<User, Exception>> signInWithKakao() async {
    try {
      // 토큰 발급하기
      kakao.OAuthToken? token;
      if (await kakao.isKakaoTalkInstalled()) {
        token = await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      if (token.idToken != null) {
        final provider = 'oidc.kakao';
        final idToken = token.idToken!; // idToken 언래핑
        final accessToken = token.accessToken;

        final result = await _connectFirebaseAuth(provider, idToken, accessToken);
        final authUser = switch (result) {
          Success(value: final user) => user,
          Failure(exception: final e) => throw e,
        };

        return Success(authUser);
      } else {
        return Failure(Exception('signInWithKakao Error'));
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }

  Future<Result<User, Exception>> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple
          .getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      if (credential.idToken != null && credential.accessToken != null) {
        final result = await _connectFirebaseAuth(credential.providerId, credential.idToken!, credential.accessToken!);
        final authUser = switch (result) {
          Success(value: final user) => user,
          Failure(exception: final e) => throw e,
        };
        return Success(authUser);
      } else {
        return Failure(Exception('signInWithApple Error'));
      }

    } on Exception catch (error) {
      return Failure(error);
    }
  }

  /// Firebase Auth
  Future<Result<User, Exception>> _connectFirebaseAuth(String provider, String idToken, String accessToken) async {
    try {
      // OAuthCredential 생성
      final OAuthCredential credential = OAuthProvider(provider).credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Firebase에 자격 증명으로 로그인
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 현재 로그인된 사용자 정보 가져오기
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        return Success(user);
      } else {
        return Failure(Exception('User 정보 가져오기 실패 에러 발생 Error'));
      }
    } catch (error) {
      return Failure(Exception(error));
    }
  }

}