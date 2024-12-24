import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService():_auth=FirebaseAuth.instance{
    _auth.setLanguageCode('kr');
  }

  /// 카카오 로그인
  Future<void> signInWithKakao() async {
    var provider = OAuthProvider("oidc.kakao");

    try {
      OAuthToken? token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken, // 카카오 로그인에서 발급된 accessToken
      );

      // Sign in with the credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      var user = await UserApi.instance.me();
      await userCredential.user?.updateProfile(displayName: "${user.id}${user.kakaoAccount?.profile?.nickname}");

    } on KakaoAuthException catch (kakaoError) {
      // KakaoAuthException 처리
      switch (kakaoError.message) {
        case 'Some specific error message':
        // 특정 에러 메시지에 대한 처리
          print('Kakao Auth Error: ${kakaoError.message}');
          break;
        default:
          print('Kakao Auth Error: $kakaoError');
      }
      throw Exception('Kakao Authentication failed: ${kakaoError.message}'); // 에러를 던짐
    } on FirebaseAuthException catch (firebaseError) {
      // FirebaseAuthException 처리
      switch (firebaseError.code) {
        case 'user-not-found':
          print('No user found for that email.');
          break;
        case 'wrong-password':
          print('Wrong password provided for that user.');
          break;
        default:
          print('Firebase Auth Error: $firebaseError');
      }
      throw Exception('Firebase Authentication failed: ${firebaseError.message}'); // 에러를 던짐
    } catch (error) {
      // 다른 모든 예외 처리
      print('An unexpected error occurred: $error');
      throw Exception('Unexpected error occurred: $error'); // 에러를 던짐
    }
  }

  Future<void> signOutWithKakao() async {

  }

  Future<void> signInWithApple() async {
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

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on SignInWithAppleAuthorizationException catch (appleError) {
      throw Exception(
          'SignInWithAppleAuthorizationException Authentication failed: ${appleError.message}'); // 에러를 던짐
    } catch (error) {
      throw Exception('Apple Authentication failed: $error');
    }
  }
}