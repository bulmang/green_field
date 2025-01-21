import 'dart:io';

import 'package:green_field/src/datas/repositories/notice_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/services/firebase_auth_service.dart';
import '../../model/notice.dart';
import '../../model/user.dart';

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
        state = AsyncData(noticeList);
        return Success(noticeList);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  Notice getNoticeById(String id) {
    return state.value!.firstWhere((notice) => notice.id == id, orElse: () {
      throw Exception('Notice not found');
    });
  }
}