import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/model/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart';
import '../../utilities/enums/user_type.dart';
import '../onboarding/onboarding_view_model.dart';

part 'post_view_model.g.dart';

@Riverpod(keepAlive: true)
class PostViewModel extends _$PostViewModel {

  @override
  Future<List<Post>> build() async {
    state = AsyncLoading();
    final result = await getPostList();
    switch (result) {

      case Success(value: final postList):
        for(var post in postList)
          print(post.id);

        return postList;
      case Failure(exception: final e):
        return [];
      default:
        return [];
    }
  }

  /// Post 리스트 가져오기
  Future<Result<List<Post>, Exception>> getPostList() async {
    state = AsyncLoading();
    final result = await ref
        .read(postRepositoryProvider) // Update repository
        .getPostList();

    switch (result) {
      case Success(value: final postList):
        state = AsyncData(postList);
        return Success(postList);
      case Failure(exception: final exception):
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// Post 다음 리스트 가져오기
  Future<Result<List<Post>, Exception>> getNextPostList() async {
    final result = await ref
        .read(postRepositoryProvider) // Update repository
        .getNextPostList(state.value);

    switch (result) {
      case Success(value: final postList):
        return Success(postList);
      case Failure(exception: final exception):
        return Failure(Exception(exception));
    }
  }

  /// 특정 Post 가져오기
  Future<Result<Post, Exception>> getPost(String postId) async {
    final userState = ref.watch(onboardingViewModelProvider);
    if (userState.value == null) return Failure(Exception('유저가 없습니다.'));

    final result = await ref
        .read(postRepositoryProvider) // Update repository
        .getPost(postId, userState.value!);

    switch (result) {
      case Success(value: final post):
        _updatePostInList(postId, post);
        return Success(post);
      case Failure(exception: final exception):
        return Failure(Exception(exception));
    }
  }

  /// 특정 Post 업데이트
  void _updatePostInList(String postId, Post updatedPost) {
    if (state.value!.isNotEmpty) {
      final index = state.value!.indexWhere((post) => post.id == postId);

      if (index != -1) {
        state.value![index] = updatedPost;
      } else {
        print('Post with ID $postId not found.');
      }
    }
  }

  /// 특정 Post 제거
  void deletePostInList(String postId) {
    if (state.value!.isNotEmpty) {
      final currentList = state.value ?? [];

      final updatedList = currentList.where((post) => post.id != postId).toList();

      state = AsyncData(updatedList);
    }
  }

  /// 권한 확인
  bool checkAuth(String? userType, String userId, String postId) {
    print(userId);
    print(postId);
    return userType == getUserTypeName(UserType.master) || userId == postId;
  }

  Post getPostById(String id) {
    return state.value!.firstWhere((post) => post.id == id, orElse: () {
      throw Exception('Post not found');
    });
  }

  void showToast(String alarmMessage, ToastGravity gravity, Color backGroundColor, Color textColor) {
    Fluttertoast.showToast(
      msg: alarmMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backGroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
