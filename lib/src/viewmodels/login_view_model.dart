import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/datas/repositories/login_repository.dart';
import 'package:green_field/src/viewmodels/user_view_model.dart';

class LoginViewModel {
  final _loginRepository = LoginRepository();
  final userVM = UserViewModel();

  Future<Result<void, Exception>> signInWithKakao() async {
    final result = await _loginRepository.signInWithKakao();

    switch (result) {
      case Success(value: final user):
        userVM.user = user;
        return Success('카카오 로그인 성공');
      case Failure(exception: final e):
        return Failure(Exception('로그인 실패: $e'));
    }
  }

  Future<Result<void, Exception>> signInWithApple() async {
    final result = await _loginRepository.signInWithApple();

    switch (result) {
      case Success(value: final user):
        userVM.user = user;
        return Success('애플 로그인 성공');
      case Failure(exception: final e):
        return Failure(Exception('로그인 실패: $e'));
    }
  }
}
