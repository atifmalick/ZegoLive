import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/features/feed/data/models/comment_model.dart';
import 'package:tapp/features/feed/data/models/post_model.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

abstract class IFeedGraphqlDataSource {
  /// Get posts
  //Future<List<PostModel>> getPosts(String id)

  /// Get nearby users and its posts
  Future<List<PostModel>> getNearbyPosts(String uid, double radius);

  /// Create a new post
  Future<PostModel> createPost(
    Map<String, dynamic> data,
    TappUser creator,
  );

  /// Get comments from a post
  Future<List<CommentModel>> getComments(String postId, String ownerId);

  /// Add a comment to post
  Future<CommentModel> addComment(Map<String, dynamic> data);

  /// Like or dislike a post
  Future<void> toggleLike(Map<String, dynamic> data);

  /// Block a user
  Future<void> blockUser(Map<String, dynamic> data);

  /// Block a user
  Future<void> reportPost(Map<String, dynamic> data);

  /// Delete a post
  Future<void> deletePost(Map<String, dynamic> data);

  // Follow User
  Future<void> followUser(String userId);

  Future<void> unFollowUser(String userId);
}

@Injectable(as: IFeedGraphqlDataSource)
class FeedGraphqlDataSource implements IFeedGraphqlDataSource {
  final GraphQLClient _client;

  FeedGraphqlDataSource(this._client);

  @override
  Future<List<PostModel>> getNearbyPosts(String uid, double radius) async {
    // print(uid);
    const query = """
      query(\$userId: ID!, \$radius: Float!) {
        user(id: \$userId) {
          uid
          nearbyUsers(radius: \$radius) {
            userId
            userInfo {
              uid
              username
              profilePicture {
                url
              }
              verified
              posts(take: 30) {
                content {
                  url
                  contentType
                }
                message
                likes
                reportCount
                date
                postId
                isStream
                isStreamLive
                comments(take: 1) {
                  username
                  userId
                  message
                  date
                  commentId
                }
              }
            }
          }
        }
      }
    """;
    // reportCount

    final options = QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'userId': uid, 'radius': radius},
    );

    final response = await _client.query(options);
    if (kDebugMode) {
      print(response.data);
    }

    if (response.data == null) {
      print(response.exception);
      return []; // no post
    }

    if (!response.hasException) {
      List<PostModel> posts = [];
      final List<dynamic> nearbyUsers = response.data!['user']['nearbyUsers'];

      for (var u in nearbyUsers) {
        final List<dynamic> userPosts = u['userInfo']['posts'];
        if (userPosts.isNotEmpty) {
          for (var post in userPosts) {
            posts.add(PostModel.fromJson(post, jsonCreator: u['userInfo']));
          }
        }
      }

      posts.sort((a, b) => b.date.compareTo(a.date));

      return posts;
    } else {
      if (kDebugMode) {
        print(response.exception);
      }
      throw GraphqlServerException(
        'No se han podido cargar las publicaciones cerca de ti.',
      );
    }
  }

  @override
  Future<PostModel> createPost(
      Map<String, dynamic> data, TappUser creator) async {
    const mutation = """
      mutation(\$data: NewPostInput!) {
        sendPost(data: \$data) {
          userId
          content {
            url
            contentType
          }
          message
          likes
          dislikes
          date
          postId
          userData {
            username
          }
        }
      }
    """;
    if (kDebugMode) {
      print("-------   posting content ----------- ");
    }
    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'data': data,
      },
    );

    final response = await _client.mutate(options);
    if (kDebugMode) {
      print(response.data);
    }
    if (!response.hasException) {
      return PostModel.fromJson(
        response.data!['sendPost'],
        jsonCreator: creator.toJson(),
      );
    } else {
      if (kDebugMode) {
        print("------- exception during  posting content ----------- ");
        print(response.exception);
      }
      throw GraphqlServerException(
        'No se pudo subir tu publicación, inténtalo más tarde',
      );
    }
  }

  @override
  Future<List<CommentModel>> getComments(String postId, String ownerId) async {
    const query = """
      query(\$postId: ID!, \$userId: ID!){
        comments(postId: \$postId, userId: \$userId){
          commentId,
          date,
          likes,
          message,
          userId,
          username,
        }
      }
    """;

    final options = QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'postId': postId,
          'userId': ownerId,
        });

    final response = await _client.query(options);

    if (!response.hasException) {
      final List<dynamic> list = response.data!['comments'];
      final comments = list.map((c) => CommentModel.fromJson(c)).toList();

      comments.sort((a, b) => b.date.compareTo(a.date));

      return comments;
    } else {
      throw GraphqlServerException('Error al cargar los comentarios.');
    }
  }

  @override
  Future<void> toggleLike(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: TogglePostReactionInput!) {
        toggleLikePost(data: \$data)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'data': data},
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException(
        'Ocurrió un error inténtalo más tarde',
      );
    }
  }

  @override
  Future<CommentModel> addComment(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: NewCommentInput!){
        commentPost(data: \$data){
          commentId
          date
          likes
          message
          username
          userId
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'data': data},
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return CommentModel.fromJson(response.data!['commentPost']);
    } else {
      throw GraphqlServerException('Ocurrió un error, inténtalo más tarde.');
    }
  }

  @override
  Future<void> blockUser(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: NewBlockedUserInput!){
        blockUser(data: \$data){
          uid
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: data,
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      print(response.exception);
      throw GraphqlServerException(
        'No se ha podido bloquear al usuario en este momento, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<void> reportPost(Map<String, dynamic> data) async {
    print(data);
    const mutation = """
      mutation(\$data: NewReportInput!){
        reportPost(data: \$data){
          refId
          reason
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: data,
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      print(response.exception);
      throw GraphqlServerException(
        'Error al reportar el post, intenta más tarde.',
      );
    }
  }

  @override
  Future<void> deletePost(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: RemovePostArgs!){
        removePost(data: \$data){
          postId
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: data,
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException(
          'Error al eliminar el post, intentalo más tarde.');
    }
  }

  @override
  Future<void> followUser(String userId) async {
    const mutation = '''
    mutation(\$userId: ID!) {
      follow(userId: \$userId) {
        uid
      }
    }
    ''';

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'userId': userId},
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException('Error al seguir al usuario');
    }
  }

  @override
  Future<void> unFollowUser(String userId) async {
    const mutation = '''
    mutation(\$userId: ID!) {
      unfollow(userId: \$userId) {
        uid
      }
    }
    ''';

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'userId': userId},
    );

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException('Error al dejar de seguir al usuario');
    }
  }
}
