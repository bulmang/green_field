import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/model/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart';
import '../../model/user.dart';
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
    final getUser = await ref.read(onboardingViewModelProvider.notifier).getUser();

    switch(getUser) {
      case Success(value: final user):
        final result = await ref
            .read(postRepositoryProvider)
            .getPostList(user);

        switch (result) {
          case Success(value: final postList):
            state = AsyncData(postList);
            return Success(postList);
          case Failure(exception: final exception):
            state = AsyncError(exception, StackTrace.current);
            return Failure(Exception(exception));
        }
      case Failure(exception: final e):
        return Failure(Exception(e));
    }
  }

  /// Post 리스트 가져오기(로딩없음)
  Future<Result<List<Post>, Exception>> getPostListNoLoading() async {
    final getUser = await ref.read(onboardingViewModelProvider.notifier).getUser();

    switch(getUser) {
      case Success(value: final user):
        final result = await ref
            .read(postRepositoryProvider)
            .getPostList(user);

        switch (result) {
          case Success(value: final postList):
            state = AsyncData(postList);
            return Success(postList);
          case Failure(exception: final exception):
            state = AsyncError(exception, StackTrace.current);
            return Failure(Exception(exception));
        }
      case Failure(exception: final e):
        return Failure(Exception(e));
    }
  }


  /// Post 다음 리스트 가져오기
  Future<Result<List<Post>, Exception>> getNextPostList() async {
    final getUser = await ref.read(onboardingViewModelProvider.notifier).getUser();

    switch(getUser) {
      case Success(value: final user):
        final result = await ref
            .read(postRepositoryProvider) // Update repository
            .getNextPostList(state.value, user);

        switch (result) {
          case Success(value: final postList):
            return Success(postList);
          case Failure(exception: final exception):
            return Failure(Exception(exception));
        }
      case Failure(exception: final e):
        return Failure(Exception(e));
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
  Future<Result<List<Post>, Exception>> deletePostInList(String postId) async {
    if (state.value!.isNotEmpty) {
      final currentList = state.value ?? [];

      final updatedList = currentList.where((post) => post.id != postId).toList();
      state = AsyncData(updatedList);
      return Success(updatedList);
    }
    return Failure(Exception('에러 발생'));
  }

  Result<Post, Exception> getCurrentPost(String postId, List<Post>? postList) {
    if (postList == null || postList.isEmpty) {
      return Failure(Exception('Post list is empty'));
    }

    try {
      final currentPost = postList.firstWhere((post) => post.id == postId);
      return Success(currentPost);
    } catch (e) {
      return Failure(Exception('Post not found'));
    }
  }


  /// 특정 Post 좋아요 업데이트 함수
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId) async { // Update method name
    try {
      state = AsyncLoading();
      final result = await ref
          .read(postRepositoryProvider) // Update repository
          .addLikeToPost(postId, userId);

      switch (result) {
        case Success(value: final post):
          if (state.value!.isNotEmpty) {
            final currentList = state.value ?? [];
            final index = state.value!.indexWhere((post) => post.id == postId);
            if (index != -1) {
              currentList[index] = post;
              state = AsyncData(currentList);
            } else {
              state = AsyncData([]);
            }
          }
          return Success(post);
        case Failure(exception: final exception):
          print('exception: $exception');
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      print('exception: $error');
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('좋아요 업데이트 실패: $error')); // Update message
    }
  }

  /// 특정 Post 신고하기
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason) async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(postRepositoryProvider) // 신고 API 호출
          .reportPost(postId, userId, reason);

      switch (result) {
        case Success(value: final post):
          if (state.value!.isNotEmpty) {
            final currentList = state.value ?? [];
            final index = state.value!.indexWhere((post) => post.id == postId);
            if (index != -1) {
              currentList[index] = post;
              state = AsyncData(currentList);
            } else {
              state = AsyncData([]);
            }
          }
          return Success(post);
        case Failure(exception: final exception):
          print('exception: $exception');
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      print('exception: $error');
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('게시글 신고 실패: $error'));
    }
  }

  /// 특정 유저 차단하기
  Future<Result<void, Exception>> blockUser(Post post, String userId) async {
    try {
      final result = await ref
          .read(postRepositoryProvider) // 신고 API 호출
          .blockUser(post, userId);

      switch (result) {
        case Success(value: final v):
          final getUser = await ref.read(onboardingViewModelProvider.notifier).getUser();

          switch(getUser) {
            case Success(value: final value):
              return Success(v);
            case Failure(exception: final e):
              return Failure(Exception(e));
          }

        case Failure(exception: final exception):
          print('exception: $exception');
          return Failure(Exception(exception));
      }
    } catch (error) {
      print('exception: $error');
      return Failure(Exception('게시글 신고 실패: $error'));
    }
  }


  /// 특정 Post 댓글 개수 업데이트 함수
  Future<Result<Post, Exception>> updateCommentCount(String postId) async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(postRepositoryProvider)
          .updateCommentCount(postId);

      switch (result) {
        case Success(value: final post):
          if (state.value!.isNotEmpty) {
            final currentList = state.value ?? [];
            final index = state.value!.indexWhere((post) => post.id == postId);
            if (index != -1) {
              currentList[index] = post;
              state = AsyncData(currentList);
            } else {
              state = AsyncData([]);
            }
          }
          return Success(post);
        case Failure(exception: final exception):
          print('exception: $exception');
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      print('exception: $error');
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('좋아요 업데이트 실패: $error')); // Update message
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
