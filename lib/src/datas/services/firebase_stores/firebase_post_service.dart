import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;

import '../../../cores/error_handler/result.dart';
import '../../../domains/interfaces/post_service_interface.dart';
import '../../../model/comment.dart';
import '../../../model/post.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as Client;

class FirebasePostService implements PostServiceInterface {
  FirebasePostService(this._store);

  final firebase_store.FirebaseFirestore _store;

  @override
  Future<Result<Post, Exception>> createPostDB(Post post, Client.User user) async {
    try {
      await _store.collection('Post').doc(post.id).set(post.toMap());
      return Success(post);
    } catch (e) {
      return Failure(Exception('post 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> deletePostDB(String postId, Client.User user) async {
    try {
      await _store.collection('Post').doc(postId).delete();
      return Success(null);
    } catch (e) {
      return Failure(Exception('post 데이터 삭제 실패: $e'));
    }
  }

  @override
  Future<Result<Post, Exception>> updatePostDB(Post post, Client.User user) async {
    try {
      await _store.collection('Post').doc(post.id).update(post.toMap());
      return Success(post);
    } catch (e) {
      return Failure(Exception('post 데이터 업데이트 실패: $e'));
    }
  }

  @override
  Future<Result<List<Post>, Exception>> getPostList() async {
    try {
      final query = _store.collection('Post').orderBy('created_at', descending: true).limit(100);
      final querySnapshot = await query.get();

      final postList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final commentCount = await _getCommentCount(doc.id);
        return Post.fromMap({...data!, 'id': doc.id, 'commentCount': commentCount});
      }));

      return Success(postList);
    } catch (e) {
      return Failure(Exception('모든 포스트 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost) async {
    try {
      var query = _store.collection('Post').orderBy('created_at', descending: true).limit(15);

      if (lastPost != null && lastPost.isNotEmpty) {
        final lastDoc = await _store.collection('Post').doc(lastPost.last.id).get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      final newPosts = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final commentCount = await _getCommentCount(doc.id);
        return Post.fromMap({...data!, 'id': doc.id, 'commentCount': commentCount});
      }));

      return Success([...lastPost ?? [], ...newPosts]);
    } catch (e) {
      return Failure(Exception('getNextPostList 함수 에러: $e'));
    }
  }

  @override
  Future<Result<Post, Exception>> getPost(String postId, Client.User user) async {
    try {
      final doc = await _store.collection('Post').doc(postId).get();
      if (doc.exists) {
        return Success(Post.fromMap({...doc.data()!, 'id': doc.id}));
      }
      return Failure(Exception('데이터가 존재하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('포스트 데이터 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason) async {
    try {
      await _store.collection('Post').doc(postId).update({
        'reported_users': firebase_store.FieldValue.arrayUnion([userId]),
      });
      return await _getUpdatedPost(postId);
    } catch (e) {
      return Failure(Exception('신고 기능 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> blockUser(Post post, String userId) async {
    try {
      await _store.collection('User').doc(userId).update({
        'blocked_user': firebase_store.FieldValue.arrayUnion([post.creatorId]),
      });
      return Success(null);
    } catch (e) {
      return Failure(Exception('차단 기능 실패: $e'));
    }
  }

  @override
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId) async {
    try {
      await _store.collection('Post').doc(postId).update({
        'like': firebase_store.FieldValue.arrayUnion([userId]),
      });
      return await _getUpdatedPost(postId);
    } catch (e) {
      return Failure(Exception('좋아요 추가 실패: $e'));
    }
  }

  @override
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report) async {
    try {
      final collectionPath = commentId != null ? 'Comment' : 'Post';
      await _store.collection('Report').doc(collectionPath).collection(report.id).doc(report.type).set(report.toMap());
      return Success(null);
    } catch (e) {
      return Failure(Exception('신고 데이터 생성 실패: $e'));
    }
  }

  @override
  Future<Result<List<Comment>, Exception>> getCommentList(String postId) async {
    try {
      final snapshot = await _store.collection('Post').doc(postId).collection('Comment').orderBy('created_at').get();
      final comments = snapshot.docs.map((doc) => Comment.fromMap({...doc.data(), 'id': doc.id})).toList();
      return Success(comments);
    } catch (e) {
      return Failure(Exception('댓글 목록 가져오기 실패: $e'));
    }
  }

  @override
  Future<Result<Comment, Exception>> createCommentDB(Post post, Comment comment) async {
    try {
      await _store.collection('Post').doc(post.id).collection('Comment').doc(comment.id).set(comment.toMap());
      if (post.creatorId != comment.creatorId) {
        await _store.collection('Post').doc(post.id).update({
          'comment_id': firebase_store.FieldValue.arrayUnion([comment.creatorId]),
        });
      }
      return Success(comment);
    } catch (e) {
      return Failure(Exception('댓글 생성 실패: $e'));
    }
  }

  @override
  Future<Result<List<Comment>, Exception>> deleteCommentDB(String postId, String commentId) async {
    try {
      await _store.collection('Post').doc(postId).collection('Comment').doc(commentId).delete();
      final snapshot = await _store.collection('Post').doc(postId).collection('Comment').orderBy('created_at').get();
      final comments = snapshot.docs.map((doc) => Comment.fromMap({...doc.data(), 'id': doc.id})).toList();
      return Success(comments);
    } catch (e) {
      return Failure(Exception('댓글 데이터 삭제 실패: $e'));
    }
  }

  @override
  Future<Result<Post, Exception>> updateCommentCount(String postId) async {
    try {
      final countSnapshot = await _store.collection('Post').doc(postId).collection('Comment').count().get();
      await _store.collection('Post').doc(postId).update({'commentCount': countSnapshot.count});
      return await _getUpdatedPost(postId);
    } catch (e) {
      return Failure(Exception('댓글 개수 업데이트 실패: $e'));
    }
  }

  Future<int?> _getCommentCount(String postId) async {
    try {
      final snapshot = await _store.collection('Post').doc(postId).collection('Comment').count().get();
      return snapshot.count;
    } catch (e) {
      return 0;
    }
  }

  Future<Result<Post, Exception>> _getUpdatedPost(String postId) async {
    final doc = await _store.collection('Post').doc(postId).get();
    if (doc.exists) {
      return Success(Post.fromMap({...doc.data()!, 'id': doc.id}));
    }
    return Failure(Exception('업데이트된 포스트를 찾을 수 없습니다.'));
  }
}
