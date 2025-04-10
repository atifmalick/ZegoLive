import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tapp/graphql_livestream_queries.dart';

class LiveStreamService {
  final GraphQLClient _client;

  LiveStreamService(this._client); 

  Future<Map<String, dynamic>> startNewStream(
      Map<String, dynamic> input) async {
    final result = await _client.mutate(MutationOptions(
      document: gql(startNewStreamMutation),
      variables: {'input': input},
    ));
    log(result.toString());
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data!['startNewStream'];
  }

  Future<Map<String, dynamic>> joinStream(Map<String, dynamic> input) async {
    final result = await _client.mutate(MutationOptions(
      document: gql(joinStreamMutation),
      variables: {'input': input},
    ));
    log(result.toString());
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data!['joinStream'];
  }

  Future<bool> endStream(Map<String, dynamic> input) async {
    final result = await _client.mutate(MutationOptions(
      document: gql(endStreamMutation),
      variables: {'input': input},
    ));
    log(result.toString());
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data!['endStream']['success'];
  }
}
