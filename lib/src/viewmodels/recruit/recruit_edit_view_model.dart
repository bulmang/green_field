import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../cores/image_type/image_type.dart';
import '../../datas/repositories/recruit_repository.dart';
import '../../model/recruit.dart';
import '../../model/user.dart';
import '../../utilities/design_system/app_colors.dart';
import '../onboarding/onboarding_view_model.dart';

part 'recruit_edit_view_model.g.dart';

@Riverpod(keepAlive: true)
class RecruitEditViewModel extends _$RecruitEditViewModel {

  @override
  Future<Recruit?> build() async {
    return null;
  }


  /// Recruit 객체 생성
  Future<Result<Recruit, Exception>> createRecruittModel(
      User? user,
      String title,
      String body,
      List<ImageType>? images,
      Recruit? pastRecruit, // Update parameter
      ) async {
    if (user == null) return Failure(Exception('로그인 상태가 아닙니다.'));
    state = AsyncLoading();
    final settingState = ref.read(recruitSettingProvider);

    final Uuid uuid = Uuid();
    String recruitId = pastRecruit?.id ?? uuid.v4();

    final DateTime date = pastRecruit?.createdAt ?? DateTime.now();

    final recruit = Recruit(
      id: recruitId,
      creatorId: user.id,
      remainTime: DateTime.now().add(Duration(minutes: settingState.selectedTime)),
      currentParticipants: [user.id],
      maxParticipants: settingState.selectedPerson,
      creatorCampus: user.campus,
      isEntryAvailable: true,
      title: title,
      body: body,
      createdAt: date,
    );

    final result = await ref
        .read(recruitRepositoryProvider) // Update repository
        .createRecruitDB(user, recruit, images);

    switch (result) {
      case Success(value: final Recruit recruit): // Update type
        state = AsyncData(recruit);
        return Success(recruit);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// 글을 수정할 때 기존 글과 이미지를 가져오는 함수
  List<ImageType> loadPostForEditing(
      TextEditingController title,
      TextEditingController body,
      List<ImageType> tempImages,
      Recruit? recruit, // Update parameter
      ) {
    if (recruit != null) {
      title.text = recruit.title;
      body.text = recruit.body;

      if (recruit.images != null && recruit.images!.isNotEmpty) {
        tempImages.addAll(recruit.images!.map((url) => UrlImage(url)).toList());
      }
    }
    return tempImages;
  }


  /// Recruit 객체 삭제
  Future<Result<void, Exception>> deleteRecruitModel(String recruitId) async { // Update method name
    try {
      state = AsyncLoading();
      final userState = ref.watch(onboardingViewModelProvider);
      if(userState.value == null) return Failure(Exception('유저가 없습니다.'));

      final result = await ref
          .read(recruitRepositoryProvider) // Update repository
          .deleteRecruitDB(recruitId, userState.value!);

      switch (result) {
        case Success():
          state = AsyncData(null);
          return Success(null);
        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      return Failure(Exception('포스트 삭제 실패: $error')); // Update message
    }
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
  void flutterToast(String alarmMessage, {Color? backgroundColor}) {
    Fluttertoast.showToast(
      msg: alarmMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor ?? AppColorsTheme.main().gfWarningColor,
      textColor: AppColorsTheme.main().gfWhiteColor,
      fontSize: 16.0,
    );
  }

}

class RecruitSettingState {
  final int selectedTime;
  final int selectedTimeListIndex;
  final int selectedPerson;
  final int selectedPersonListIndex;

  RecruitSettingState({required this.selectedTime, required this.selectedTimeListIndex, required this.selectedPerson, required this.selectedPersonListIndex});

  RecruitSettingState copyWith({int? selectedTime, int? selectedTimeListIndex, int? selectedPerson, int? selectedPersonListIndex}) {
    return RecruitSettingState(
      selectedTime: selectedTime ?? this.selectedTime,
      selectedTimeListIndex: selectedTimeListIndex ?? this.selectedTimeListIndex,
      selectedPerson: selectedPerson ?? this.selectedPerson,
      selectedPersonListIndex: selectedPersonListIndex ?? this.selectedPersonListIndex,
    );
  }
}

class RecruitSettingNotifier extends StateNotifier<RecruitSettingState> {
  RecruitSettingNotifier() : super(RecruitSettingState(selectedTime: 60, selectedPerson: 4, selectedTimeListIndex: 0, selectedPersonListIndex: 2));

  void updateSelectedTime(int limitTime) {
    state = state.copyWith(selectedTime: limitTime);
  }

  void updateSelectedTimeListIndex(int index) {
    state = state.copyWith(selectedTimeListIndex: index);
  }

  void updateSelectedPerson(int personCount) {
    state = state.copyWith(selectedPerson: personCount);
  }

  void updateSelectedPersonListIndex(int index) {
    state = state.copyWith(selectedPersonListIndex: index);
  }
}

final recruitSettingProvider = StateNotifierProvider<RecruitSettingNotifier, RecruitSettingState>(
      (ref) => RecruitSettingNotifier(),
);
