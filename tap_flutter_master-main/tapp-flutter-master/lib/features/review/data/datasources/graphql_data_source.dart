import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';

abstract class IReviewGraphqlDataSource {
  Future<Map<String, dynamic>> sendReview(Map<String, dynamic> data);
}

@Injectable(as: IReviewGraphqlDataSource)
class ReviewGraphqlDataSource implements IReviewGraphqlDataSource {
  final GraphQLClient _graphQLClient;
  ReviewGraphqlDataSource(this._graphQLClient);
  @override
  Future<Map<String, dynamic>> sendReview(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: UserReviewInput!) {
        sendReview(data: \$data){
            userId
            subject
            message
        }
      }
    """;

    // final options = MutationOptions(document: gql(mutation), variables: data);
    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'data': data,
      },
    );

    final response = await _graphQLClient.mutate(options);
    if (!response.hasException) {
      if (kDebugMode) {
        print('has no exceptionn');
      }

      // final List<dynamic> list = response.data!['review'];
      var list = response.data!;
      return list;
    } else {
      if (kDebugMode) {
        print(response.exception);
      }
      throw GraphqlServerException(
          'Ocurrio un error al mandar tu reseña de la app, intentalo más tarde.');
    }
  }
}
