import '../../cores/error_handler/result.dart';
import '../../model/comment.dart';
import '../../model/post.dart';
import '../../model/report.dart';
import '../../model/user.dart' as Client;

abstract class PostServiceInterface {
  /// 게시글 생성
  Future<Result<Post, Exception>> createPostDB(Post post, Client.User user);

  /// 게시글 삭제
  Future<Result<void, Exception>> deletePostDB(String postId, Client.User user);

  /// 게시글 수정
  Future<Result<Post, Exception>> updatePostDB(Post post, Client.User user);

  /// 게시글 목록 조회
  Future<Result<List<Post>, Exception>> getPostList();

  /// 게시글 추가 목록 조회
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost);

  /// 특정 게시글 조회
  Future<Result<Post, Exception>> getPost(String postId, Client.User user);

  /// 게시글 신고
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason);

  /// 게시글 유저 차단
  Future<Result<void, Exception>> blockUser(Post post, String userId);

  /// 게시글 좋아요 추가
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId);

  /// 댓글 신고 기능
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report);

  /// 댓글 목록 조회
  Future<Result<List<Comment>, Exception>> getCommentList(String postId);

  /// 댓글 생성
  Future<Result<Comment, Exception>> createCommentDB(Post post, Comment comment);

  /// 댓글 삭제
  Future<Result<List<Comment>, Exception>> deleteCommentDB(String postId, String commentId);

  /// 댓글 수 업데이트
  Future<Result<Post, Exception>> updateCommentCount(String postId);

}
