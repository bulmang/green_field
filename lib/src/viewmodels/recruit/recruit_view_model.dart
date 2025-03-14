import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../cores/image_type/image_type.dart';
import '../../datas/repositories/recruit_repository.dart';
import '../../model/recruit.dart';
import '../../model/user.dart';
import '../../utilities/enums/user_type.dart';
import '../onboarding/onboarding_view_model.dart';

part 'recruit_view_model.g.dart';

@Riverpod(keepAlive: true)
class RecruitViewModel extends _$RecruitViewModel {
  @override
  Future<List<Recruit>> build() async {
    state = AsyncLoading();
    final result = await getRecruitList();
    switch (result) {
      case Success(value: final recruitList):
        return recruitList;
      case Failure(exception: final e):
        return [];
    }
  }

  final exampleRecruit = Recruit(
    id: '1234567890',
    title: '모집글 제목',
    body: '모집글 내용입니다. 새로운 멤버를 모집합니다.',
    remainTime: DateTime.now().add(Duration(days: 3)),
    currentParticipants: ['user1', 'user2'],
    maxParticipants: 10, creatorId: '', creatorCampus: '', isEntryAvailable: false, createdAt: DateTime.now(),
  );

  /// Recruit 리스트 가져오기
  Future<Result<List<Recruit>, Exception>> getRecruitList() async {
    state = AsyncLoading();
    final result = await ref
        .read(recruitRepositoryProvider) // Update repository
        .getRecruitList();

    switch (result) {
      case Success(value: final postList):
        state = AsyncData(postList);
        return Success(postList);
      case Failure(exception: final exception):
        print('exception: $exception');
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// 특정 Recruit 가져오기
  Future<Result<Recruit, Exception>> getRecruit(String recruitId) async {
    final userState = ref.watch(onboardingViewModelProvider);
    if (userState.value == null) return Failure(Exception('유저가 없습니다.'));

    final result = await ref
        .read(recruitRepositoryProvider)
        .getRecruit(recruitId, userState.value!);

    switch (result) {
      case Success(value: final recruit):
        _updateRecruitInList(recruitId, recruit);
        return Success(recruit);
      case Failure(exception: final exception):
        return Failure(Exception(exception));
    }
  }

  /// 특정 Recruit 업데이트
  void _updateRecruitInList(String recruitId, Recruit updatedRecruit) {
    if (state.value!.isNotEmpty) {
      final index = state.value!.indexWhere((recruit) => recruit.id == recruitId);
      if (index != -1) {
        state.value![index] = updatedRecruit;
      } else {
        print('Recruit with ID $recruitId not found.');
      }
    }
  }

  /// 특정 Recruit 제거
  Future<Result<List<Recruit>, Exception>> deleteRecruitInList(String postId) async {
    if (state.value!.isNotEmpty) {
      final currentList = state.value ?? [];

      final updatedList = currentList.where((post) => post.id != postId).toList();
      state = AsyncData(updatedList);
      return Success(updatedList);
    }
    return Failure(Exception('에러 발생'));
  }

  /// 특정 Recruit 신고하기
  Future<Result<Recruit, Exception>> reportRecruit(String recruitId, String userId, String reason) async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(recruitRepositoryProvider)
          .reportRecruit(recruitId, userId, reason);

      switch (result) {
        case Success(value: final post):
          if (state.value!.isNotEmpty) {
            final currentList = state.value ?? [];
            final index = state.value!.indexWhere((recruit) => recruit.id == recruitId);
            if (index != -1) {
              currentList[index] = post;
              state = AsyncData(currentList);
            } else {
              state = AsyncData([]);
            }
          }
          return Success(post);
        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('모집글 신고 실패: $error'));
    }
  }

  bool isEntryChatRoomActive(int currentPeopleCount, int maxPeopleCount) {
    if (currentPeopleCount >= maxPeopleCount) {
      return false;
    } else {
      return true;
    }
  }

  /// 권한 확인
  bool checkAuth(String? userType, String userId, String postId) {
    if (userType == null) return false;
    if (userType ==  getUserTypeName(UserType.master)) {
      return true;
    } else if (userId == postId) {
      return true;
    } else {
      return false;
    }
  }

  Recruit getRecruitById(String id) {
    return state.value!.firstWhere((recruit) => recruit.id == id, orElse: () {
      throw Exception('Recruit not found');
    });
  }
}