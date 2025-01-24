import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/datas/repositories/notice_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/services/firebase_auth_service.dart';
import '../../model/notice.dart';
import '../../model/user.dart';
import '../../utilities/design_system/app_colors.dart';

part 'notice_view_model.g.dart';

@Riverpod(keepAlive: true)
class NoticeViewModel extends _$NoticeViewModel {

  @override
  Future<List<Notice>?> build() async {
    state = AsyncLoading();
    final result = await getNoticeList();
    switch (result) {

      case Success(value: final noticeList):
        return noticeList;
      case Failure(exception: final e):
        return [];
      default:
        return [];
    }
  }

  /// Notice 리스트 가져오기
  Future<Result<List<Notice>, Exception>> getNoticeList() async {
    state = AsyncLoading();
    final result = await ref
        .read(noticeRepositoryProvider)
        .getNoticeList();

    switch (result) {
      case Success(value: final noticeList):
        print('noticeList: ${noticeList.toString()}');
        state = AsyncData(noticeList);
        return Success(noticeList);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// Notice 리스트 가져오기
  Future<Result<List<Notice>, Exception>> getNextNoticeList() async {

    final result = await ref
        .read(noticeRepositoryProvider)
        .getNextNoticeList(state.value);

    switch (result) {
      case Success(value: final noticeList):
        print('noticeList: ${noticeList.toString()}');

        return Success(noticeList);
      case Failure(exception: final exception):
        return Failure(Exception(exception));
    }
  }


  Notice getNoticeById(String id) {
    return state.value!.firstWhere((notice) => notice.id == id, orElse: () {
      throw Exception('Notice not found');
    });
  }

  void showToast(String alarmMessage, ToastGravity gravity,Color backGroundColor, Color textColor) {
    Fluttertoast.showToast(
      msg: alarmMessage, // 메시지 내용
      toastLength: Toast.LENGTH_SHORT, // 메시지 시간 - 안드로이드
      gravity: gravity, // 메시지 위치
      timeInSecForIosWeb: 1, // 메시지 시간 - iOS 및 웹
      backgroundColor: backGroundColor, // 배경
      textColor: textColor, // 글자
      fontSize: 16.0,
    );
  }
}