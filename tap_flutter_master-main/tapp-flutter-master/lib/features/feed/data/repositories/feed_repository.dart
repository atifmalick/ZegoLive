import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/feed/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

@LazySingleton(as: IFeedRepository)
class FeedRepository implements IFeedRepository {
  final IFeedGraphqlDataSource _graphqlDataSource;

  FeedRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, List<Post>>> getNearbyPosts(
      String uid, double radius) async {
    try {
      final posts = await _graphqlDataSource.getNearbyPosts(uid, radius);

      return right(posts);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(
      Map<String, dynamic> data, TappUser creator) async {
    try {
      final post = await _graphqlDataSource.createPost(data, creator);
      return right(post);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments(
    String postId,
    String ownerId,
  ) async {
    try {
      final comments = await _graphqlDataSource.getComments(postId, ownerId);
      return right(comments);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleLike(Map<String, dynamic> data) async {
    try {
      await _graphqlDataSource.toggleLike(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(Map<String, dynamic> data) async {
    try {
      final comment = await _graphqlDataSource.addComment(data);
      return right(comment);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> blockUser(Map<String, dynamic> data) async {
    try {
      await _graphqlDataSource.blockUser(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> reportPost(Map<String, dynamic> data) async {
    try {
      await _graphqlDataSource.reportPost(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(Map<String, dynamic> data) async {
    try {
      await _graphqlDataSource.deletePost(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> followUser(String uid) async {
    try {
      await _graphqlDataSource.followUser(uid);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> unFollowUser(String uid) async {
    try {
      await _graphqlDataSource.unFollowUser(uid);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, Unit>> removeFollowerUser(String uid) async {
  //   try {
  //     await _graphqlDataSource.removeFollowerUser(uid);
  //     return right(unit);
  //   } on GraphqlServerException catch (e) {
  //     return left(GraphqlFailure(e.message));
  //   }
  // }
}
