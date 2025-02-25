import 'package:green_field/src/datas/repositories/setting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/login_repository.dart';

part 'setting_view_model.g.dart'; // 생성된 코드를 위한 파일

@Riverpod(keepAlive: true)
class SettingViewModel extends _$SettingViewModel {
  @override
  Future<void> build() async {
    return;
  }

  Future<Result<void, Exception>> signOut() async {
    state = AsyncLoading();
    try {
      final result = await ref.read(settingRepositoryProvider).signOut();

      switch (result) {
        case Success():
          state = AsyncData(null);
          return Success(null);

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('로그아웃 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('로그아웃 중 예외 발생: $e'));
    }
  }

  Future<Result<void, Exception>> deleteUser(String userId) async {
    state = AsyncLoading();
    try {
      final result = await ref.read(settingRepositoryProvider).deleteUser(userId);

      switch (result) {
        case Success():
          state = AsyncData(null); // 탈퇴 후 상태 초기화
          return Success(null);

        case Failure(exception: final e):
          print(e);
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('회원 탈퇴 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('회원 탈퇴 중 예외 발생: $e'));
    }
  }

}