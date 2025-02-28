import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/datas/repositories/onboarding_repository.dart';
import 'package:green_field/src/utilities/enums/user_type.dart';
import '../../model/notice.dart';
import '../../model/post.dart';
import '../../model/report.dart';
import '../../model/user.dart' as GFUser;

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
  Future<Result<GFUser.User, Exception>> getUserById(String userId) async {
    try {
      final docSnapshot = await _store.collection('User').doc(userId).get();

      if (docSnapshot.exists) {
        final userData = GFUser.User.fromMap(docSnapshot.data()!);

        return Success(userData);
      } else {
        return Failure(Exception(
            'firebase_store_service _getUserById error: 사용자를 찾을 수 없습니다.'));
      }
    } catch (e) {
      return Failure(Exception('사용자 데이터 가져오기 실패: $e'));
    }
  }

  /// UserDB 삭제 함수
  Future<Result<void, Exception>> deleteUserDB(String userId) async {
    try {
      // Firestore에서 사용자 문서 삭제
      await _store.collection('User').doc(userId).delete();
      return Success(null); // 성공적으로 삭제되었음을 나타냄
    } catch (e) {
      return Failure(Exception('사용자 데이터 삭제 실패: $e'));
    }
  }



  /// Notice Collection 생성 및 Notice 데이터 추가
  Future<Result<Notice, Exception>> createNoticeDB(Notice notice, GFUser.User user) async {
    try {
      if(user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) return Failure(Exception('인증 되지 않은 사용자입니다.'));
      var campusDocRef = _store.collection('Campus').doc(user.campus);

      await campusDocRef.collection('Notice').doc(notice.id).set(notice.toMap());

      return Success(notice);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 생성 실패: $e'));
    }
  }

  /// Notice Collection에서 Notice 데이터 삭제
  Future<Result<void, Exception>> deleteNoticeDB(String noticeId, GFUser.User user) async {
    try {
      if(user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) return Failure(Exception('인증 되지 않은 사용자입니다.'));
      await _store.collection('Campus').doc(user.campus ?? '관악').collection('Notice').doc(noticeId).delete();

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 삭제 실패: $e'));
    }
  }

  /// Notice Collection의 특정 Notice 데이터 업데이트
  Future<Result<Notice, Exception>> updateNoticeDB(Notice notice, GFUser.User user) async {
    try {
      if(user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) return Failure(Exception('인증 되지 않은 사용자입니다.'));
      // Firestore에서 해당 문서 업데이트
      await _store
          .collection('Campus').doc(user.campus).collection('Notice')
          .doc(notice.id).update(notice.toMap());

      return Success(notice);
    } catch (e) {
      print(e);
      return Failure(Exception('notice 데이터 업데이트 실패: $e'));
    }
  }

  /// Notice List 가져오기
  Future<Result<List<Notice>, Exception>> getNoticeList(GFUser.User? user) async {
    try {
      print("user : $user");
      // 기본 쿼리
      var query = _store
          .collection('Campus').doc(user == null ? '관악' : user.campus)
          .collection('Notice').orderBy('created_at', descending: true)
          .limit(15);

      // 첫 번째 페이지 또는 페이징 데이터를 가져오기
      var querySnapshot = await query.get();

      // 데이터를 Notice 객체로 매핑
      List<Notice> noticeList = querySnapshot.docs
          .map((doc) => Notice.fromMap(doc.data()))
          .toList();

      if (noticeList.isEmpty) {
        return Success([]);
      } else {
        return Success(noticeList);
      }
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
    }
  }

  /// Notice List 추가로 가져오기
  Future<Result<List<Notice>, Exception>> getNextNoticeList(List<Notice>? lastNotice, GFUser.User user) async {
    try {
      var query = _store
          .collection('Campus').doc(user.campus == '익명' ? '관악' : user.campus)
          .collection('Notice').orderBy('created_at', descending: true)
          .limit(10);

      if (lastNotice != [] && lastNotice != null) {
        final lastDoc = await _store.collection('Campus').doc(user.campus == '익명' ? '관악' : user.campus).collection('Notice')
            .doc(lastNotice.last.id)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      var querySnapshot = await query.get();

      List<Notice> noticeList = querySnapshot.docs
          .map((doc) => Notice.fromMap(doc.data()))
          .toList();

      if (noticeList.isEmpty) {
        return Success([]);
      } else {
        if (lastNotice != null)
          lastNotice!.addAll(noticeList);

        return Success(lastNotice ?? noticeList);
      }
    } catch (e) {
      return Failure(Exception('getNextNoticeList 함수 에러: $e'));
    }
  }

  /// 특정 Notice 가져오기
  Future<Result<Notice, Exception>> getNotice(String noticeId, GFUser.User user) async {
    try {
      // Firestore에서 특정 문서 가져오기
      final documentSnapshot = await _store
          .collection('Campus').doc(user.campus == '익명' ? '관악' : user.campus)
          .collection('Notice').doc(noticeId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          // Firestore 데이터를 Notice 객체로 변환
          final notice = Notice.fromMap({
            ...data,
            'id': documentSnapshot.id, // 문서 ID를 직접 추가
          });
          return Success(notice);
        }
      }
      return Failure(Exception('데이터가 존재 하지 않습니다.'));
    } catch (e) {
      return Failure(Exception('공지사항 데이터 가져오기 실패: $e'));
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
          .collection('Post').orderBy('created_at', descending: true)
          .limit(100);

      // 첫 번째 페이지 또는 페이징 데이터를 가져오기
      var querySnapshot = await query.get();

      // 데이터를 Notice 객체로 매핑
      List<Post> postList = querySnapshot.docs
          .map((doc) => Post.fromMap(doc.data()))
          .toList();

      if (postList.isEmpty) {
        return Success([]);
      } else {
        return Success(postList);
      }
    } catch (e) {
      return Failure(Exception('모든 포스트 가져오기 실패: $e'));
    }
  }


  /// Post List 추가로 가져오기
  Future<Result<List<Post>, Exception>> getNextPostList(List<Post>? lastPost) async {
    try {
      var query = _store.collection('Post').orderBy('created_at', descending: true).limit(15);

      if (lastPost != [] && lastPost != null) {
        final lastDoc = await _store.collection('Post').doc(lastPost.last.id).get();
        query = query.startAfterDocument(lastDoc);
      }

      var querySnapshot = await query.get();

      List<Post> postList = querySnapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();

      if (postList.isEmpty) {
        return Success([]);
      } else {
        if (lastPost != null) lastPost!.addAll(postList);

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

  /// Post Collection 생성 및 Post 데이터 추가
  Future<Result<void, Exception>> createReportDB(Report report) async {
    try {
      await _store.collection('Report').doc(report.id).set(report.toMap());

      return Success(null);
    } catch (e) {
      print(e);
      return Failure(Exception('post 데이터 생성 실패: $e'));
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
      if (user.campus == '익명' || user.userType == getUserTypeName(UserType.student)) {
        return Failure(Exception('인증 되지 않은 사용자입니다.'));
      }

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

}
