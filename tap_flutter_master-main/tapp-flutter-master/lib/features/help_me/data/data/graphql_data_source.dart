import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';

abstract class IHelpMeGraphqlDataSource {
  /// Send Help Me alert
  Future<void> sendHelpMeAlert(Map<String, dynamic> data);

  Future<void> addContact(Map<String, dynamic> data);
}

@Injectable(as: IHelpMeGraphqlDataSource)
class HelpMeGraphqlDataSource implements IHelpMeGraphqlDataSource {
  final GraphQLClient _client;

  const HelpMeGraphqlDataSource(this._client);

  @override
  Future<void> sendHelpMeAlert(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: HelpMeAlertInput!){
        sendHelpMeAlert(data: \$data)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: data,
    );

    final result = await _client.mutate(options);

    if (!result.hasException) {
      return;
    } else {
      if (kDebugMode) {
        print('sssssssssssssss');
        print(result.exception.toString());
      }
      throw GraphqlServerException(
        'Ocurrió un error al mandar la alerta, intenta otra vez',
      );
    }
  }

  @override
  Future<void> addContact(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: UserTrustListInput!) {
        addUserToTrustList(data: \$data)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: data,
    );

    final result = await _client.mutate(options);

    if (!result.hasException) {
      return;
    } else {
      throw GraphqlServerException(
          'Ocurrio un error al agregar a contactos de confianza');
    }
  }
}
