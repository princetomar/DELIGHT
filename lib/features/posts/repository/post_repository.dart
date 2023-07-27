import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delight/core/constants/firebase_constants.dart';
import 'package:delight/core/failure.dart';
import 'package:delight/core/providers/firebase_providers.dart';
import 'package:delight/core/type_def.dart';
import 'package:delight/models/comment_model.dart';
import 'package:delight/models/community_model.dart';
import 'package:delight/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // To add post to a community
  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where(
          "communityName",
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // To upvote a post
  void upvote(Post post, String userId) async {
    // if post already contains the user id in upvotes list as a downvote
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    // if post already contains the user id in upvotes list as an upvote
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // To downvote a post
  void downvote(Post post, String userId) async {
    // if post already contains the user id in downvotes list as an upvote
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    // if post already contains the user id in downvotes list as a downvote
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // Function to get post by id
  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  // Function to comment on a post
  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentCollection);
}
