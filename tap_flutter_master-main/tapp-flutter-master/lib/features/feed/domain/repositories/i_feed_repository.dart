import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

abstract class IFeedRepository {
  /// Get nearby users and its posts
  Future<Either<Failure, List<Post>>> getNearbyPosts(String uid, double radius);

  /// Create or upload a new post
  Future<Either<Failure, Post>> createPost(
      Map<String, dynamic> data, TappUser creator);

  /// Get comments from a post
  Future<Either<Failure, List<Comment>>> getComments(
    String postId,
    String ownerId,
  );

  /// Add a comment
  Future<Either<Failure, Comment>> addComment(Map<String, dynamic> data);

  /// Toggle like or dislike
  Future<Either<Failure, Unit>> toggleLike(Map<String, dynamic> data);

  /// Block a user
  Future<Either<Failure, Unit>> blockUser(Map<String, dynamic> data);

  /// Report post
  Future<Either<Failure, Unit>> reportPost(Map<String, dynamic> data);

  /// Delete post
  Future<Either<Failure, Unit>> deletePost(Map<String, dynamic> data);

  // Follow User
  Future<Either<Failure, Unit>> followUser(String userId);

  // Follow User
  Future<Either<Failure, Unit>> unFollowUser(String userId);
}
