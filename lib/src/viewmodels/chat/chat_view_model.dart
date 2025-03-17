
import 'package:green_field/src/datas/repositories/chat_repository.dart';
import 'package:green_field/src/model/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart';
import '../../model/post.dart';
import '../../model/recruit.dart';
import '../../model/user.dart';

part 'chat_view_model.g.dart';

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel {
  @override
  Future<List<Message>> build() async {
    return [];
  }

  /// 메시지 조회하기 (스트림 사용)
  Stream<List<Message>> getMessageListStream(String recruitId) {
    return ref.watch(chatRepositoryProvider).getMessageListStream(recruitId);
  }

  /// 메시지 조회하기
  Future<Result<List<Message>, Exception>> getMessageList(String recruitId) async {
    state = AsyncLoading();
    final result = await ref
        .read(chatRepositoryProvider) // Update repository
        .getMessageList(recruitId);

    switch (result) {
      case Success(value: final messageList):
        state = AsyncData(messageList);
        return Success(messageList);
      case Failure(exception: final exception):
        print('exception: $exception');
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }

  /// 메시지 생성하기
  Future<Result<Message, Exception>> createMessage(Recruit recruit, User user, String chatNickName, String messageText) async {
    try {

      final Uuid uuid = Uuid();
      final message = Message(
          id: uuid.v4(),
          roomId: recruit.id,
          userId: user.id,
          userName: chatNickName,
          text: messageText,
          createdAt: DateTime.now(),
      );

      final result = await ref
          .read(chatRepositoryProvider) // 댓글 추가 API 호출
          .createMessageDB(recruit, message);

      switch (result) {
        case Success(value: final comment):
          return Success(comment);

        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('메세지 추가 실패: $error'));
    }
  }

  /// 댓글 삭제하기
  // Future<Result<List<Comment>, Exception>> deleteCommentModel(String postId, String commentID) async { // Update method name
  //   try {
  //     state = AsyncLoading();
  //
  //     final result = await ref
  //         .read(postRepositoryProvider) // Update repository
  //         .deleteCommentDB(postId, commentID);
  //
  //     switch (result) {
  //       case Success(value: final commentList):
  //         state = AsyncData(commentList);
  //         return Success(commentList);
  //       case Failure(exception: final exception):
  //         state = AsyncError(exception, StackTrace.current);
  //         return Failure(Exception(exception));
  //     }
  //   } catch (error) {
  //     return Failure(Exception('포스트 삭제 실패: $error')); // Update message
  //   }
  // }

  /// 댓글 초기화
  // void resetCommentList() async {
  //   state = AsyncData([]);
  // }

  /// 댓글 신고
  // Future<Result<void, Exception>> reportComment(String postId, String commentId,String userId, String reason) async {
  //   try {
  //     state = AsyncLoading();
  //     final result = await ref
  //         .read(postRepositoryProvider) // 신고 API 호출
  //         .reportComment(postId, commentId, userId, reason);
  //
  //     switch (result) {
  //       case Success(value: final comment):
  //         state = AsyncData([]);
  //         return Success(comment);
  //       case Failure(exception: final exception):
  //         state = AsyncError(exception, StackTrace.current);
  //         return Failure(Exception(exception));
  //     }
  //   } catch (error) {
  //     state = AsyncError(error, StackTrace.current);
  //     return Failure(Exception('댓글 신고 실패: $error'));
  //   }
  // }
}