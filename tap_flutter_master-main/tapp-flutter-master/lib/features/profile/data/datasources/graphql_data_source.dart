import 'dart:developer';

import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/features/profile/data/models/tapp_user_model.dart';

abstract class IProfileGraphqlDataSource {
  /// Update user's profile info on social standard server
  Future<TappUserModel> updateUserInfo(Map<String, dynamic> data);

  /// Update user location
  Future<void> updateUserLocation(Map<String, dynamic> data);

  /// Get user's info from social standard graphql server
  Future<TappUserModel> getAllUserInfo();

  /// Get users's in trustlist
  Future<List<TappUserModel>> getTrustList(String uid);

  /// Add user to trustlist
  Future<void> addUserToTrustList(Map<String, dynamic> data);

  /// Remove user from trustlist
  Future<void> removeUserFromTrustList(Map<String, dynamic> data);

  // follow users
  Future<void> followUser(String uid);

  // Unfollow user
  Future<void> unfollowUser(String uid);

  // Get following user
  Future<List<TappUserModel>> followingUsers(String uid);

  // Get followers
  Future<List<TappUserModel>> followersUsers(String uid);

  Future<void> removeFollowerUser(String userId);
}

@Injectable(as: IProfileGraphqlDataSource)
class ProfileGraphqlDataSource implements IProfileGraphqlDataSource {
  final GraphQLClient _client;

  ProfileGraphqlDataSource(this._client);

  @override
  Future<TappUserModel> updateUserInfo(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$userData: UpdateUserInput!){
        updateUser(data: \$userData){
          name
          lastName
          username
          email
          description
          profilePicture {
            url
          }
          isProfilePictureEnabled
          phone
          maritalStatus
          language
          birthday
          hobby
          sexualPreference
          occupation
          gender
          messagingToken
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
      return TappUserModel.fromJson(response.data!['updateUser']);
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al actualizar la información, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<void> updateUserLocation(Map<String, dynamic> data) async {
    const mutation = """
      mutation (\$data : UpdateGeolocationInput!) {
        updateGeolocation (data: \$data){
          longitude
          latitude
        }
      }
    """;
    // ult = await _repository.updateUserLocation({
    //   "data": {
    //     "latitude": latitude,
    //     "longitude": longitude,
    //   }
    // });

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
        'Ocurrió un error al actualizar la ubicación.',
      );
    }
  }

  @override
  Future<TappUserModel> getAllUserInfo() async {
    const query = """
      query {
        currentUser {
          uid
          name
          lastName
          username
          email
          verified
          description
          profilePicture {
            url
          }
          isProfilePictureEnabled
          phone
          
          maritalStatus
          language
          hobby
          sexualPreference
          occupation
          gender
          birthday
          messagingToken
          following {
            uid
            name
            username
            email
            lastName
            verified
            isRegionalAlly
          }
          followingCount
          followerCount
        }
      }
    """;
// todo birthday
    final options = QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.networkOnly,
    );
    log("Here", name: 'response');
    final response = await _client.query(options);
    log(response.toString(), name: 'response');
    if (!response.hasException) {
      Map<String, dynamic> user = response.data!['currentUser'];

      Map<String, dynamic> parsedUserFollowing = {
        ...user,
        'following': ((user['following'] ?? []) as List)
            .map<String>((e) => e['uid'])
            .toList(),
        'followers': ((user['followers'] ?? []) as List)
            .map<String>((e) => e['uid'])
            .toList(),
      };

      return TappUserModel.fromJson(parsedUserFollowing);
    } else {
      throw GraphqlServerException(response.exception.toString());
    }
  }

  @override
  Future<void> addUserToTrustList(Map<String, dynamic> data) async {
    const mutation = """
      mutation (\$data : UserTrustListInput!) {
        addUserToTrustList(data: \$data)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'data': data,
      },
    );

    final response = await _client.mutate(options);

    if (response.data!['addUserToTrustList']) {
      return;
    } else {
      throw GraphqlServerException(
        'El nombre de usuario es incorrecto o el usuario no existe.',
      );
    }
  }

  @override
  Future<List<TappUserModel>> getTrustList(String uid) async {
    String query = """
      query(\$uid: ID!) {
        user(id: \$uid) {
          trustList
        }
      }
    """;

    QueryOptions options = QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'uid': uid,
      },
    );

    QueryResult response = await _client.query(options);

    if (!response.hasException) {
      final List<dynamic>? trustList = response.data!['user']['trustList'];

      if (trustList != null) {
        query = """
          query(\$uids: [ID!]) {
            users(only: \$uids) {
              uid,
              username,
              name,
              lastName,
            }
          }
        """;

        options = QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'uids': trustList},
        );

        response = await _client.query(options);

        if (!response.hasException) {
          final List<dynamic> userList = response.data!['users'];
          return userList.map((u) => TappUserModel.fromJson(u)).toList();
        } else {
          print(response.exception);
          throw GraphqlServerException(
            'Error al obtener la lista de contactos de confianza.',
          );
        }
      } else {
        return [];
      }
    } else {
      throw GraphqlServerException(
        'Error al obtener la lista de contactos de confianza.',
      );
    }
  }

  @override
  Future<void> removeUserFromTrustList(Map<String, dynamic> data) async {
    const mutation = """
      mutation (\$removeUserId : ID!) {
        removeUserFromTrustList(removeUserId: \$removeUserId)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'removeUserId': data['removeUserId']},
    );

    final response = await _client.mutate(options);

    if (response.data!['removeUserFromTrustList']) {
      return;
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al eliminar el contacto, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<void> followUser(String uid) async {
    const mutation = '''
     mutation(\$userId:ID!) {
      follow(userId:\$userId) {
       uid
      }
   }
    ''';

    final options = MutationOptions(
        document: gql(mutation),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {'userId': uid});

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException('Error al dejar de seguir al usuario');
    }
  }

  @override
  Future<void> unfollowUser(String uid) async {
    const mutation = '''
       mutation(\$userId:ID!) {
        unfollow(uid:\$userId) {
         uid
         }
      }
    ''';

    final options = MutationOptions(
        document: gql(mutation),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {'userId': uid});

    final response = await _client.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException('Error al dejar de seguir al usuario');
    }
  }

  @override
  Future<List<TappUserModel>> followingUsers(String uid) async {
    String query = '''
      query(\$uid: ID!){
        user(id: \$uid) {
          following{
            name
            username
            uid
            verified
          }
        }
      }
    ''';

    QueryOptions options = QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'uid': uid,
        });

    QueryResult response = await _client.query(options);
    if (!response.hasException) {
      // final List<dynamic>? following =
      //     response.data!['user']['following'].map((u) => u['uid']).toList();

      // if (following != null) {
      //   query = '''
      //     query(\$uids: [ID!]) {
      //       users(only: \$uids) {
      //         uid,
      //         username,
      //         name,
      //         lastName,
      //       }
      //     }
      //   ''';

      //   options = QueryOptions(
      //       document: gql(query),
      //       fetchPolicy: FetchPolicy.networkOnly,
      //       variables: {'uids': following});

      //   response = await _client.query(options);

      // if (!response.hasException) {
      final List<dynamic>? following =
          response.data!['user']['following'].map((u) => u).toList();
      // final List<dynamic> followingUsers = response.data!['users'];
      return following!.map((u) => TappUserModel.fromJson(u)).toList();
    } else {
      throw GraphqlServerException("Error al obtener a los usuarios");
    }
    // } else {
    //   return [];
    // }
    // } else {
    //   throw GraphqlServerException("Error al obtener a los usuarios");
    // }
  }

  @override
  Future<List<TappUserModel>> followersUsers(String uid) async {
    String query = '''
      query(\$uid: ID!){
        user(id: \$uid) {
          followers{
            name
            username
            uid
            verified
          }
        }
      }
    ''';

    QueryOptions options = QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'uid': uid,
        });

    QueryResult response = await _client.query(options);

    if (!response.hasException) {
      // if (following != null) {
      //   query = '''
      //     query(\$uids: [ID!]) {
      //       users(only: \$uids) {
      //         uid,
      //         username,
      //         name,
      //         lastName,
      //       }
      //     }
      //   ''';

      //   options = QueryOptions(
      //       document: gql(query),
      //       fetchPolicy: FetchPolicy.networkOnly,
      //       variables: {'uids': following});

      //   response = await _client.query(options);

      // if (!response.hasException) {
      final List<dynamic>? followers = response.data!['user']['followers'];
      // final List<dynamic> followersUsers = response.data!['users'];
      return followers!.map((u) => TappUserModel.fromJson(u)).toList();
    } else {
      throw GraphqlServerException("Error al obtener a los usuarios");
    }
    // } else {
    //   return [];
    // }
    // } else {
    //   throw GraphqlServerException("Error al obtener a los usuarios");
    // }
  }

  @override
  Future<void> removeFollowerUser(String userId) async {
    const mutation = '''
    mutation(\$userId: ID!) {
      removeFollower(userId: \$userId) {
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
