
import 'package:green_field/src/model/comment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart';
import '../../model/post.dart';
import '../../model/user.dart';

part 'post_detail_view_model.g.dart';

@Riverpod(keepAlive: true)
class PostDetailViewModel extends _$PostDetailViewModel {
  @override
  Future<List<Comment>> build() async {
    return [];
  }

  /// 댓글 조회하기
  Future<Result<List<Comment>, Exception>> getCommentList(String postId) async {
    state = AsyncLoading();
    final result = await ref
        .read(postRepositoryProvider) // Update repository
        .getCommentList(postId);

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

  /// 댓글 생성하기
  Future<Result<Comment, Exception>> createComment(Post post, User user, String commentText) async {
    try {

      final Uuid uuid = Uuid();
      final comment = Comment(
        id: uuid.v4(),
        creatorId: user.id,
        creatorCampus: user.campus,
        body: commentText,
        createdAt: DateTime.now(),
      );

      final result = await ref
          .read(postRepositoryProvider) // 댓글 추가 API 호출
          .createCommentDB(post, comment);

      switch (result) {
        case Success(value: final comment):
          return Success(comment);

        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('댓글 추가 실패: $error'));
    }
  }

  /// Post 객체 삭제
  Future<Result<List<Comment>, Exception>> deleteCommentModel(String postId, String commentID) async { // Update method name
    try {
      state = AsyncLoading();

      final result = await ref
          .read(postRepositoryProvider) // Update repository
          .deleteCommentDB(postId, commentID);

      switch (result) {
        case Success(value: final commentList):
          state = AsyncData(commentList);
          return Success(commentList);
        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      return Failure(Exception('포스트 삭제 실패: $error')); // Update message
    }
  }

  /// 특정 Comment 제거
  Future<Result<List<Comment>, Exception>> deleteCommentInList(String commentId) async {
    if (state.value!.isNotEmpty) {
      final currentList = state.value ?? [];

      final updatedList = currentList.where((comment) => comment.id != commentId).toList();
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


  /// 댓글 초기화
  void resetCommentList() async {
    state = AsyncData([]);
  }

  /// 댓글 신고
  Future<Result<void, Exception>> reportComment(String postId, String commentId,String userId, String reason) async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(postRepositoryProvider) // 신고 API 호출
          .reportComment(postId, commentId, userId, reason);

      switch (result) {
        case Success(value: final comment):
          state = AsyncData([]);
          return Success(comment);
        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('댓글 신고 실패: $error'));
    }
  }
}