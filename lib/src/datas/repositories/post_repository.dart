import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/datas/services/firebase_stores/firebase_store_post_service.dart';
import 'package:green_field/src/domains/interfaces/post_service_interface.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../model/post.dart';
import '../../model/report.dart';
import '../../model/user.dart';
import '../services/firebase_storage_service.dart';

class PostRepository {
  final PostServiceInterface service;
  final FirebaseStorageService firebaseStorageService;

  PostRepository({required this.service, required this.firebaseStorageService});

  /// 게시글 목록 조회
  Future<Result<List<Post>, Exception>> getPostList(User? user) async {
    try {
      final result = await service.getPostList();

      switch(result) {
        case Success(value: final postList):
          if (user != null) {
            // 1. 신고된  게시물 필터링 (현재 사용자 ID가 reportedUsers에 포함된 경우 제외)
            final filteredReportPostList = postList.where((post) =>
            !post.reportedUsers.contains(user.id)
            ).toList();

            // 2. 차단 사용자 조건 적용
            final filteredPostList = filteredReportPostList.where((post) {
              var containsBlockedUser = user.blockedUser.contains(
                  post.creatorId);
              return !containsBlockedUser; // 차단 사용자 포함 시 제외
            }).toList();
            return Success(filteredPostList);
          } else {
            return Success(postList);
          }
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 게시글 추가 목록 조회
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost, User? user) async {
    try {
      final result = await service.getNextPostList(lastPost);

      switch(result) {
        case Success(value: final postList):
          if (user != null) {
            // 1. 신고된  게시물 필터링 (현재 사용자 ID가 reportedUsers에 포함된 경우 제외)
            final filteredReportPostList = postList.where((post) =>
            !post.reportedUsers.contains(user.id)
            ).toList();

            // 2. 차단 사용자 조건 적용
            final filteredPostList = filteredReportPostList.where((post) {
              var containsBlockedUser = user.blockedUser.contains(
                  post.creatorId);
              return !containsBlockedUser; // 차단 사용자 포함 시 제외
            }).toList();
            return Success(filteredPostList);
          } else {
            return Success(postList);
          }
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 게시글 생성
  Future<Result<Post, Exception>> createPostDB(User user, Post post, List<ImageType>? images) async {
    try {
      final uploadImageResult = await uploadImage(user, images);

      switch(uploadImageResult) {
        case Success(value: final imageUrls):
          post.images = imageUrls;
          final result = await service.createPostDB(post, user);

          switch (result) {
            case Success(value: final post):
              return Success(post);
            case Failure(exception: final exception):
              return Failure(exception);
          }
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 특정 게시글 조회
  Future<Result<Post, Exception>> getPost(String postId, User user) async {
    try {
      final result = await service.getPost(postId, user);

      switch(result) {
        case Success(value: final postId):
          return Success(postId);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 게시글 삭제
  Future<Result<void, Exception>> deletePostDB(String postId, User user) async {
    try {
      final result = await service.deletePostDB(postId, user);

      switch (result) {
        case Success():
          return Success(null);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('포스트 삭제 실패: $error'));
    }
  }

  /// 게시글 좋아요 추가
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId) async {
    try {
      final result = await service.addLikeToPost(postId, userId);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('좋아요 업데이트 실패: $error'));
    }
  }

  /// 댓글 신고 기능
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason) async {
    try {
      final result = await service.reportPost(postId, userId, reason);

      switch (result) {
        case Success(value: final v):
          await _createReport(postId, null, userId, reason);
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// 게시글 유저 차단
  Future<Result<void, Exception>> blockUser(Post post, String userId) async {
    try {
      final result = await service.blockUser(post, userId);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// 게시글 신고
  Future<Result<void, Exception>> _createReport(String postId, String? commentId, String userId, String reason) async {
    try {
      final Uuid uuid = Uuid();
      String reportID = uuid.v4();
      Report report;

      if (commentId != null) {
        report = Report(id: reportID,
            type: reason,
            reportedTargetID: commentId,
            reporterId: userId,
            createdAt: DateTime.now());
      } else {
        report = Report(id: reportID,
            type: reason,
            reportedTargetID: postId,
            reporterId: userId,
            createdAt: DateTime.now());
      }

      final result = await service.createReportDB(commentId, report);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// 댓글 목록 조회
  Future<Result<List<Comment>, Exception>> getCommentList(String postId) async {
    try {
      final result = await service.getCommentList(postId);

      switch(result) {
        case Success(value: final commentList):
          return Success(commentList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }


  /// 댓글 생성
  Future<Result<Comment, Exception>> createCommentDB(Post post, Comment comment) async {
    try {
      final result = await service.createCommentDB(post, comment);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// 댓글 신고 기능
  Future<Result<void, Exception>> reportComment(String postId, String commentId, String userId, String reason) async {
    try {
      final result = await _createReport(postId, commentId, userId, reason);
      return result;
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// 댓글 삭제
  Future<Result<List<Comment>, Exception>> deleteCommentDB(String postId, String commentId) async {
    try {
      final result = await service.deleteCommentDB(postId, commentId);

      switch (result) {
        case Success(value: final commentList):
          return Success(commentList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('포스트 삭제 실패: $error'));
    }
  }

  /// 댓글 수 업데이트
  Future<Result<Post, Exception>> updateCommentCount(String postId) async {
    try {
      final result = await service.updateCommentCount(postId);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('좋아요 업데이트 실패: $error'));
    }
  }

  /// Image 업로드 후 ImageURL 가져오기
  Future<Result<List<String>?, Exception>> uploadImage(User user, List<ImageType>? images) async {
    try {
      List<XFile> xFileImages = [];
      List<String> imageUrls = [];

      if (images != null ) {
        for (var image in images) {
          switch (image) {
            case XFileImage(: final value):
              xFileImages.add(value);
            case UrlImage(: final value):
              imageUrls.add(value);
          }
        }
      }

      final result = await firebaseStorageService.uploadImages(user, xFileImages, 'posts');

      switch (result) {
        case Success(value: final value):
          imageUrls.addAll(value ?? []);
          return Success(imageUrls);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }
}

/// PostRepositoryProvider 생성
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(
    service: FirebaseStorePostService(FirebaseFirestore.instance),
    firebaseStorageService: FirebaseStorageService(FirebaseStorage.instance),
  );
});
