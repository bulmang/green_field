import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import '../../datas/repositories/login_repository.dart';
import '../../model/token.dart';

part 'login_view_model.g.dart';

@Riverpod(keepAlive: true)
class LoginViewModel extends _$LoginViewModel {

  @override
  Future<Token> build() async {
    return Token(provider: '', providerUID: '', idToken: '', accessToken: '');
  }

  Future<Result<Token, Exception>> signInWithKakao() async {
    state = AsyncLoading();
    try {
      final result = await ref.read(loginRepositoryProvider).signInWithKakao();

      switch (result) {
        case Success(value: final token):
          state = AsyncData(token); // Token 객체를 상태로 저장
          return Success(token); // Token 객체 반환

        case Failure(exception: final e):
        // 실패 시 에러를 AsyncError에 전달
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('카카오 로그인 실패: $e'));
      }
    } catch (e, stackTrace) {
      // 예외가 발생한 경우 AsyncError에 에러와 스택 트레이스를 전달
      state = AsyncError(e, stackTrace);
      return Failure(Exception('카카오 로그인 중 예외 발생: $e'));
    }
  }


  Future<Result<Token, Exception>> signInWithApple() async {
    state = AsyncLoading();
    final result = await ref.read(loginRepositoryProvider).signInWithApple();

    switch (result) {
      case Success(value: final token):
        state = AsyncData(token);
        return Success(token);
      case Failure(exception: final e):
        state = AsyncError(e, StackTrace.current);
        return Failure(Exception('애플 로그인 실패: $e'));
    }
  }
}

