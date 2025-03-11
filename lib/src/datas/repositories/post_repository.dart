import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../model/post.dart'; // Update model import
import '../../model/report.dart';
import '../../model/user.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_stores/firebase_store_service.dart';

class PostRepository { // Update class name
  final FirebaseStoreService firebaseStoreService;
  final FirebaseStorageService firebaseStorageService;

  PostRepository({required this.firebaseStoreService, required this.firebaseStorageService});

  /// Post 리스트 가져오기
  Future<Result<List<Post>, Exception>> getPostList() async {
    try {
      final result = await firebaseStoreService.getPostList();

      switch(result) {
        case Success(value: final postList):
          return Success(postList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 다음 Post 리스트 가져오기
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost) async {
    try {
      final result = await firebaseStoreService.getNextPostList(lastPost);

      switch(result) {
        case Success(value: final postList):
          return Success(postList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// Post DB 생성
  Future<Result<Post, Exception>> createPostDB(User user, Post post, List<ImageType>? images) async {
    try {
      final uploadImageResult = await uploadImage(user, images);

      switch(uploadImageResult) {
        case Success(value: final imageUrls):
          post.images = imageUrls;
          final result = await firebaseStoreService.createPostDB(post, user);

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

  /// 특정 Post 가져오기
  Future<Result<Post, Exception>> getPost(String postId, User user) async {
    try {
      final result = await firebaseStoreService.getPost(postId, user);

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

  /// Post 문서 삭제
  Future<Result<void, Exception>> deletePostDB(String postId, User user) async {
    try {
      final result = await firebaseStoreService.deletePostDB(postId, user);

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

  /// 특정 Post에 like 추가
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId) async {
    try {
      final result = await firebaseStoreService.addLikeToPost(postId, userId);

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

  /// 특정 Post에 report 추가
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason) async {
    try {
      final result = await firebaseStoreService.reportPost(postId, userId, reason);

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

  /// Report 생성
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

      final result = await firebaseStoreService.createReportDB(commentId, report);

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

  /// Comment 리스트 가져오기
  Future<Result<List<Comment>, Exception>> getCommentList(String postId) async {
    try {
      final result = await firebaseStoreService.getCommentList(postId);

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


  /// Comment 생성
  Future<Result<Comment, Exception>> createCommentDB(Post post, Comment comment) async {
    try {
      final result = await firebaseStoreService.createCommentDB(post, comment);

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

  /// Comment 신고
  Future<Result<void, Exception>> reportComment(String postId, String commentId, String userId, String reason) async {
    try {
      final result = await _createReport(postId, commentId, userId, reason);
      return result;
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// Comment 삭제
  Future<Result<List<Comment>, Exception>> deleteCommentDB(String postId, String commentId) async {
    try {
      final result = await firebaseStoreService.deleteCommentDB(postId, commentId);

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

  /// 특정 Post에 commentCount 업데이트
  Future<Result<Post, Exception>> updateCommentCount(String postId) async {
    try {
      final result = await firebaseStoreService.updateCommentCount(postId);

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
    firebaseStoreService: FirebaseStoreService(FirebaseFirestore.instance),
    firebaseStorageService: FirebaseStorageService(FirebaseStorage.instance),
  );
});
