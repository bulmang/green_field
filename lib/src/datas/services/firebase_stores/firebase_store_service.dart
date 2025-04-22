import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/utilities/enums/user_type.dart';

import '../../../model/campus.dart';
import '../../../model/post.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as GFUser;

class   FirebaseStoreService {
  FirebaseStoreService(this._store);
  final firebase_store.FirebaseFirestore _store;

  /// user Collection 생성 및 user 데이터 추가
  Future<Result<GFUser.User, Exception>> createUserDB(GFUser.User user) async {
    try {
      // User 컬렉션에 사용자 데이터 추가
      await _store.collection('User').doc(user.id).set(user.toMap());

      return Success(user);
    } catch (e) {
      return Failure(Exception('사용자 생성 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User, Exception>> getUserByPrviderUID(String providerUID) async {
    try {
      print('UserId: $providerUID');

      // simple_login_id가 userId와 일치하는 문서 쿼리
      final querySnapshot = await _store
          .collection('User')
          .where('simple_login_id', isEqualTo: providerUID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = GFUser.User.fromMap(querySnapshot.docs.first.data());
        return Success(userData);
      } else {
        return Failure(Exception(
            'firebase_store_service _getUserBySimpleLoginId error: 사용자를 찾을 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// Firestore에서 UserId로 사용자 데이터 가져오기
  Future<Result<GFUser.User?, Exception>> getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('User').doc(userId).get();

      if (docSnapshot.exists) {
        final userData = GFUser.User.fromMap(docSnapshot.data()!);

        return Success(userData);
      } else {
        return Success(null);
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// UserDB 삭제 함수
  Future<Result<void, Exception>> deleteUserDB(String userId) async {
    try {
      // Firestore에서 사용자 문서 삭제
      print('userId: $userId');
      await _store.collection('User').doc(userId).delete();
      return Success(null); // 성공적으로 삭제되었음을 나타냄
    } catch (e) {
      return Failure(Exception('사용자 데이터 삭제 실패: $e'));
    }
  }

  /// Post Collection 생성 및 Post 데이터 추가
  Future<Result<Post, Exception>> createPostDB(Post post, GFUser.User user) async {
    try {
      await _store.collection('Post').doc(post.id).set(post.toMap());

      return Success(post);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 생성 실패: $e'));
    }
  }

  /// Post Collection에서 Post 데이터 삭제
  Future<Result<void, Exception>> deletePostDB(String postId, GFUser.User user) async {
    try {
      await _store.collection('Post').doc(postId).delete();

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 삭제 실패: $e'));
    }
  }

  /// Post Collection의 특정 Post 데이터 업데이트
  Future<Result<Post, Exception>> updatePostDB(Post post, GFUser.User user) async {
    try {

      // Firestore에서 해당 문서 업데이트
      await _store.collection('Campus').doc(user.campus).collection('Post').doc(post.id).update(post.toMap());

      return Success(post);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 업데이트 실패: $e'));
    }
  }

  /// Post List 가져오기
  Future<Result<List<Post>, Exception>> getPostList() async {
    try {
      var query = _store
          .collection('Post')
          .orderBy('created_at', descending: true)
          .limit(100);

      // 첫 번째 페이지 또는 페이징 데이터를 가져오기
      var querySnapshot = await query.get();

      // 데이터를 Post 객체로 매핑
      List<Post> postList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final commentCount = await _getCommentCount(doc.id);
        return Post.fromMap({
          ...data,
          'id': doc.id,
          'commentCount': commentCount,
        });
      }));

      if (postList.isEmpty) {
        return Success([]);
      } else {
        return Success(postList);
      }
    } catch (e) {
      return Failure(Exception('모든 포스트 가져오기 실패: $e'));
    }
  }

  /// 특정 Post의 Comment 개수 가져오기
  Future<int?> _getCommentCount(String postId) async {
    try {
      final countSnapshot = await _store
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .count()
          .get();

      return countSnapshot.count;
    } catch (e) {
      print('Comment 개수 가져오기 실패: $e');
      return 0;
    }
  }


  /// 다음 Post List 가져오기
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost) async {
    try {
      var query = _store
          .collection('Post')
          .orderBy('created_at', descending: true)
          .limit(15);

      if (lastPost != null && lastPost.isNotEmpty) {
        final lastDoc = await _store.collection('Post').doc(lastPost.last.id).get();
        query = query.startAfterDocument(lastDoc);
      }

      var querySnapshot = await query.get();

      List<Post> postList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final commentCount = await _getCommentCount(doc.id);
        return Post.fromMap({
          ...data,
          'id': doc.id,
          'commentCount': commentCount,
        });
      }));

      if (postList.isEmpty) {
        return Success([]);
      } else {
        if (lastPost != null) lastPost.addAll(postList);

        return Success(lastPost ?? postList);
      }
    } catch (e) {
      return Failure(Exception('getNextPostList 함수 에러: $e'));
    }
  }

  /// 특정 Post 가져오기
  Future<Result<Post, Exception>> getPost(String postId, GFUser.User user) async {
    try {
      print('postId $postId');
      // Firestore에서 특정 문서 가져오기
      final documentSnapshot = await _store.collection('Post').doc(postId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Post 객체로 변환
          final post = Post.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(post);
        }
      }
      return Failure(Exception('데이터가 존재 하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('포스트 데이터 가져오기 실패: $e'));
    }
  }

  /// 특정 Post에 신고 추가
  Future<Result<Post, Exception>> reportPost(String postId, String userId, String reason) async {
    try {
      await _store.collection('Post').doc(postId).update({
        'reported_users': firebase_store.FieldValue.arrayUnion([userId]),
      });

      // 업데이트된 Post 문서 가져오기
      final documentSnapshot = await _store.collection('Post').doc(postId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Post 객체로 변환
          final post = Post.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(post);
        }
      }
      return Failure(Exception('업데이트된 포스트를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('신고 기능 실패: $e'));
    }
  }

  /// 특정 Post에 차단 추가
  Future<Result<void, Exception>> blockUser(Post post, String userId) async {
    try {
      await _store.collection('User').doc(userId).update({
        'blocked_user': firebase_store.FieldValue.arrayUnion([post.creatorId]),
      });

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('차단 기능 실패: $e'));
    }
  }

  /// 특정 Post에 like 추가
  Future<Result<Post, Exception>> addLikeToPost(String postId, String userId) async {
    try {
      // Firestore에서 해당 Post 문서 업데이트
      await _store.collection('Post').doc(postId).update({
        'like': firebase_store.FieldValue.arrayUnion([userId]),
      });

      // 업데이트된 Post 문서 가져오기
      final documentSnapshot = await _store.collection('Post').doc(postId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Post 객체로 변환
          final post = Post.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(post);
        }
      }
      return Failure(Exception('업데이트된 포스트를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('좋아요 추가 실패: $e'));
    }
  }

  /// Post Collection 생성 및 Post 데이터 추가
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report) async {
    try {
      if(commentId != null) {
        await _store.collection('Report').doc('Comment').collection(report.id).doc(report.type).set(report.toMap());
      } else {
        await _store.collection('Report').doc('Post').collection(report.id).doc(report.type).set(report.toMap());
      }
      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 생성 실패: $e'));
    }
  }

  /// Comment List 가져오기
  Future<Result<List<Comment>, Exception>> getCommentList(String postId) async {
    try {
      final querySnapshot = await _store
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .orderBy('created_at')
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return Comment.fromMap({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();

      return Success(comments);
    } catch (e) {
      print('err: $e');
      return Failure(Exception('댓글 목록 가져오기 실패: $e'));
    }
  }

  /// Comment 생성
  Future<Result<Comment, Exception>> createCommentDB(Post post, Comment comment) async {
    try {
      await _store
          .collection('Post')
          .doc(post.id)
          .collection('Comment')
          .doc(comment.id)
          .set(comment.toMap());

      if (post.creatorId != comment.creatorId) {
      await _store.collection('Post').doc(post.id).update({
        'comment_id': firebase_store.FieldValue.arrayUnion([comment.creatorId]),
      });
      }

      return Success(comment);
    } catch (e) {
      print('err: $e');
      return Failure(Exception('댓글 생성 실패: $e'));
    }
  }

  /// Comment 데이터 삭제
  Future<Result<List<Comment>, Exception>> deleteCommentDB(String postId, String commentId) async {
    try {
      await _store.collection('Post').doc(postId).collection('Comment').doc(commentId).delete();

      final querySnapshot = await _store
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .orderBy('created_at')
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return Comment.fromMap({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();

      return Success(comments);
    } catch (e) {
      return Failure(Exception('댓글 데이터 삭제 실패: $e'));
    }
  }


  /// 특정 Post의 commentCount 업데이트하기
  Future<Result<Post, Exception>> updateCommentCount(String postId) async {
    try {
      // Comment 서브컬렉션의 문서 개수 가져오기
      final countSnapshot = await _store
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .count()
          .get();

      final commentCount = countSnapshot.count;

      // Firestore에서 해당 Post 문서 업데이트
      await _store.collection('Post').doc(postId).update({
        'commentCount': commentCount,
      });

      // 업데이트된 Post 문서 가져오기
      final documentSnapshot = await _store.collection('Post').doc(postId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Post 객체로 변환
          final post = Post.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(post);
        }
      }
      return Failure(Exception('업데이트된 포스트를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('댓글 개수 업데이트에 실패했습니다: $e'));
    }
  }


  /// 외부 링크 추가
  Future<Result<String, Exception>> createExternalLink(GFUser.User user, String linkID, String linkDomainName) async {
    try {
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

      var campusDocRef = _store.collection('Campus').doc(user.campus);

      // 링크를 단일 필드로 저장
      await campusDocRef.collection('ExternalLink').doc(linkID).set({'link': linkDomainName});

      return Success(linkDomainName);
    } catch (e) {
      print(e);
      return Failure(Exception('외부 링크 생성 실패: $e'));
    }
  }

  /// 외부 링크 가져오기
  Future<Result<String, Exception>> getExternalLink(GFUser.User user, String linkID) async {
    try {
      var campusDocRef = _store.collection('Campus').doc(user.campus);

      // 링크 문서 가져오기
      final docSnapshot = await campusDocRef.collection('ExternalLink').doc(linkID).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('link')) {
          return Success(data['link']);
        }
      }
      return Failure(Exception('링크를 찾을 수 없습니다.'));
    } catch (e) {
      print(e);
      return Failure(Exception('외부 링크 가져오기 실패: $e'));
    }
  }

  /// Campus 생성
  Future<Result<Campus, Exception>> createCampusDB(Campus campus) async {
    try {
      await _store
          .collection('Campus')
          .doc(campus.name)
          .collection('Information')
          .doc(campus.name)
          .set(campus.toMap());

      // 저장된 데이터를 다시 가져와 반환
      final documentSnapshot = await _store
          .collection('Campus')
          .doc(campus.name)
          .collection('Information')
          .doc(campus.id)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final savedCampus = Campus.fromMap(data);
          return Success(savedCampus);
        }
      }

      return Failure(Exception('저장된 캠퍼스 데이터를 찾을 수 없습니다.'));
    } catch (e) {
      print('err: $e');
      return Failure(Exception('캠퍼스 생성 실패: $e'));
    }
  }

  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    try {
      final documentSnapshot = await _store
          .collection('Campus')
          .doc(campusName)
          .collection('Information')
          .doc(campusName)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          final savedCampus = Campus.fromMap(data);
          return Success(savedCampus);
        }
      }

      return Failure(Exception('저장된 캠퍼스 데이터를 찾을 수 없습니다.'));
    } catch (e) {
      print('err: $e');
      return Failure(Exception('캠퍼스 데이터 가져오기 실패: $e'));
    }
  }


}
