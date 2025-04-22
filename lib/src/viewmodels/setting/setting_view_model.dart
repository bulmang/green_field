import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/datas/repositories/setting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/login_repository.dart';
import '../../model/user.dart';
import '../../utilities/design_system/app_colors.dart';

part 'setting_view_model.g.dart'; // 생성된 코드를 위한 파일

@Riverpod(keepAlive: true)
class SettingViewModel extends _$SettingViewModel {
  @override
  Future<void> build() async {
    return;
  }

  /// 사용자 로그 아웃
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

  /// 사용자 데이터 삭제
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

  /// 사용자 데이터 초기화
  Future<Result<void, Exception>> resetUser() async {
    state = AsyncLoading();
    try {
      final result = await ref.read(settingRepositoryProvider).resetUser();

      switch (result) {
        case Success():
          state = AsyncData(null); // 탈퇴 후 상태 초기화
          return Success(null);

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('익명 로그인 초기화 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('익명 로그인 초기화 중 예외 발생: $e'));
    }
  }

  /// 외부 링크 생성 (관리자 전용)
  Future<Result<String, Exception>> createExternalLink(User user, String linkID, String linkDomainName) async {
    state = AsyncLoading();
    try {
      final result = await ref.read(settingRepositoryProvider).createExternalLink(user, linkID, linkDomainName);

      switch (result) {
        case Success(value: final v):
          state = AsyncData(null);
          return Success(v);

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('외부 링크 생성 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('외부 링크 생성 실패: $e'));
    }
  }

  /// 외부 링크 조회
  Future<Result<String, Exception>> getExternalLink(User user, String linkID) async {
    state = AsyncLoading();
    try {
      final result = await ref.read(settingRepositoryProvider).getExternalLink(user, linkID);

      switch (result) {
        case Success(value: final link):
          state = AsyncData(null);
          return Success(link);

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('외부 링크 가져오기 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('외부 링크 가져오기 중 예외 발생: $e'));
    }
  }

  void showToast(
      String alarmMessage, {
        ToastGravity? gravity,
        Color? backGroundColor,
        Color? textColor,
      }) {
    Fluttertoast.showToast(
      msg: alarmMessage, // 메시지 내용
      toastLength: Toast.LENGTH_SHORT, // 메시지 시간 - 안드로이드
      gravity: gravity ?? ToastGravity.TOP, // 메시지 위치
      timeInSecForIosWeb: 1, // 메시지 시간 - iOS 및 웹
      backgroundColor: backGroundColor ?? const Color(0xFFFF6A69), // 배경
      textColor: textColor ?? const Color(0xFFFBFBFD), // 글자
      fontSize: 16.0,
    );
  }
}