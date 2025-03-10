import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart'; // Update repository
import '../../model/comment.dart';
import '../../model/post.dart'; // Update model
import '../../model/user.dart';

part 'post_edit_view_model.g.dart';

@Riverpod(keepAlive: true)
class PostEditViewModel extends _$PostEditViewModel {
  @override
  Future<Post?> build() async { // Update return type
    return null;
  }

  /// Post 객체 생성
  Future<Result<Post, Exception>> createPostModel(
      User? user,
      String title,
      String body,
      List<ImageType>? images,
      Post? pastPost, // Update parameter
      ) async {
    state = AsyncLoading();

    final Uuid uuid = Uuid();
    String postId = pastPost?.id ?? uuid.v4();

    final DateTime date = pastPost?.createdAt ?? DateTime.now();

    final post = Post( // Update object creation
      id: postId,
      creatorId: user!.id ?? '',
      creatorCampus: user.campus ?? '',
      title: title,
      body: body,
      like: pastPost?.like ?? [],
      commentCount: pastPost?.commentCount ?? 0,
      createdAt: date,
    );

    final result = await ref
        .read(postRepositoryProvider) // Update repository
        .createPostDB(user, post, images);

    switch (result) {
      case Success(value: final Post post): // Update type
        state = AsyncData(post);
        return Success(post);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// Post 객체 삭제
  Future<Result<void, Exception>> deletePostModel(String postId) async { // Update method name
    try {
      state = AsyncLoading();
      final userState = ref.watch(onboardingViewModelProvider);
      if(userState.value == null) return Failure(Exception('유저가 없습니다.'));

      final result = await ref
          .read(postRepositoryProvider) // Update repository
          .deletePostDB(postId, userState.value!);

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

  /// 글을 수정할 때 기존 글과 이미지를 가져오는 함수
  List<ImageType> loadPostForEditing(
      TextEditingController title,
      TextEditingController body,
      List<ImageType> tempImages,
      Post? post, // Update parameter
      ) {
    if (post != null) {
      title.text = post.title;
      body.text = post.body;

      if (post.images != null && post.images!.isNotEmpty) {
        tempImages.addAll(post.images!.map((url) => UrlImage(url)).toList());
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
      msg: alarmMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColorsTheme.main().gfWarningColor,
      textColor: AppColorsTheme.main().gfWhiteColor,
      fontSize: 16.0,
    );
  }

/// TODO: 테스트용 코드
 Future<void> createMultiplePosts(User user) async { // Update method name
    List<Future<Result<Post, Exception>>> futures = List.generate(40, (index) {
      return createPostModel(
        user,
        '포스트 제목 $index',
        '포스트 내용 $index 입니다.',
        [],
        null,
      );
    });

    var results = await Future.wait(futures);

    for (var result in results) {
      switch (result) {
        case Success(value: final post): // Update type
          print('✅ ${post.id} 추가 완료');
          break;
        case Failure(exception: final error):
          print('❌ 실패: $error');
          break;
      }
    }
  }
}

final likeProvider = StateNotifierProvider<LikeNotifier, bool>(
      (ref) => LikeNotifier(),
);

class LikeNotifier extends StateNotifier<bool> {
  LikeNotifier() : super(false); // 초기 상태 설정

  void toggleLike() {
    state = true; // 현재 상태를 반전시킴
  }

  void setLike(bool isLiked) {
    state = isLiked; // 상태를 특정 값으로 설정
  }
}
