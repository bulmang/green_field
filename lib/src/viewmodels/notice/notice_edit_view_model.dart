import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/notice_repository.dart';
import '../../model/notice.dart';
import '../../model/user.dart';

part 'notice_edit_view_model.g.dart';

@Riverpod(keepAlive: true)
class NoticeEditViewModel extends _$NoticeEditViewModel {
  @override
  Future<Notice?> build() async {
    return null;
  }

  /// Notice 객체 생성
  Future<Result<Notice, Exception>> createNoticeModel(
    User? user,
    String title,
    String body,
    List<ImageType>? images,
    Notice? pastNotice,
  ) async {
    state = AsyncLoading();

    final Uuid uuid = Uuid();
    String noticeId = pastNotice?.id ?? uuid.v4();

    final DateTime date = pastNotice?.createdAt ?? DateTime.now();

    final notice = Notice(
      id: noticeId,
      creatorId: user!.id ?? '',
      userCampus: user.campus ?? '',
      title: title,
      body: body,
      like: [],
      createdAt: date,
    );

    final result = await ref
        .read(noticeRepositoryProvider)
        .createNoticeDB(user, notice, images);

    switch (result) {
      case Success(value: final Notice notice):
        state = AsyncData(notice);
        return Success(notice);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// Notice 객체 삭제
  Future<Result<void, Exception>> deleteNoticeModel(String noticeId) async {
    try {
      final userState = ref.watch(onboardingViewModelProvider);
      if(userState.value == null) return Failure(Exception('유저가 없습니다.'));

      final result = await ref
          .read(noticeRepositoryProvider)
          .deleteNoticeDB(noticeId, userState.value!);

      switch (result) {
        case Success():
          return Success(null);
        case Failure(exception: final exception):
          return Failure(Exception(exception));
      }
    } catch (error) {
      return Failure(Exception('공지사항 삭제 실패: $error'));
    }
  }

  /// 글을 수정할 때 기존 글과 이미지를 가져오는 함수
  List<ImageType> loadPostForEditing(
    TextEditingController title,
    TextEditingController body,
    List<ImageType> tempImages,
    Notice? notice,
  ) {
    if (notice != null) {
      title.text = notice.title;
      body.text = notice.body;

      if (notice.images != null && notice.images!.isNotEmpty) {
        tempImages.addAll(notice.images!.map((url) => UrlImage(url)).toList());
      }
    }
    return tempImages;
  }

  /// local 사진 가져오기
  Future<void> pickImages(
      List<ImageType> tempImages, List<XFile>? images) async {
    if (images != null) {
      tempImages
          .addAll(images.map((file) => XFileImage(file) as ImageType).toList());
    }
  }

  /// 사진 제거하기
  void removeImage(List<ImageType> tempImages, int index) {
    tempImages.removeAt(index);
  }

  /// Toast Message 알람
  void flutterToast(String alarmMessage) {
    Fluttertoast.showToast(
      msg: alarmMessage, // 메시지 내용
      toastLength: Toast.LENGTH_SHORT, // 메시지 시간 - 안드로이드
      gravity: ToastGravity.TOP, // 메시지 위치
      timeInSecForIosWeb: 2, // 메시지 시간 - iOS 및 웹
      backgroundColor: AppColorsTheme.main().gfWarningColor, // 배경
      textColor: AppColorsTheme.main().gfWhiteColor, // 글자
      fontSize: 16.0,
    );
  }

  /// TODO: 테스트용 코드
/// Future<void> createMultipleNotices(User user) async {
//     List<Future<Result<Notice, Exception>>> futures = List.generate(40, (index) {
//       return createNoticeModel(
//         user,
//         '공지 제목 $index',
//         '공지 내용 $index 입니다.',
//         [],
//         null, // 이전 공지가 없으므로 null
//       );
//     });
//
//     // 모든 Notice 생성 병렬 실행
//     var results = await Future.wait(futures);
//
//     // 결과 출력 (성공/실패 확인)
//     for (var result in results) {
//       switch (result) {
//         case Success(value: final notice):
//           print('✅ ${notice.id} 추가 완료');
//           break;
//         case Failure(exception: final error):
//           print('❌ 실패: $error');
//           break;
//       }
//     }
//   }
}
