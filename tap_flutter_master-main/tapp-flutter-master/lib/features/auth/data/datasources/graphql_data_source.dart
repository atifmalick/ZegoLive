// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';

abstract class IAuthGraphqlDataSource {
  /// SignUp with email and password on social standard graphql
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> deleteAccount();
}

@Injectable(as: IAuthGraphqlDataSource)
class AuthGraphqlDataSource implements IAuthGraphqlDataSource {
  final GraphQLClient _graphQLClient;

  AuthGraphqlDataSource(this._graphQLClient);

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    const mutation = """
        mutation(\$userData: AddUserInput!){
          registerUser(data: \$userData){
            uid
          }
        }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      variables: {
        'userData': {'email': email, 'pass': password}
      },
    );

    final response = await _graphQLClient.mutate(options);

    if (response.hasException) {
      String message = "El registro no se pudo completar, inténtelo más tarde";

      if (response.exception.toString().contains("User already registered")) {
        message = "Ya existe un usuario con ese correo";
      }
      if (kDebugMode) {
        print("Error al registrar: ${response.exception}");
        print("Data: ${options.variables}");
      }
      throw GraphqlServerException(
        message,
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    const mutation = """
        mutation{
          deleteUser{
            uid
          }
        }
    """;
    final options = MutationOptions(
      document: gql(mutation),
      variables: {},
    );

    try {
      final response = await _graphQLClient.mutate(options);
      if (response.hasException) {
        if (kDebugMode) {
          print("Error al eliminar: ${response.exception}");
        }
        throw GraphqlServerException(
          "No se pudo eliminar la cuenta, inténtelo más tarde",
        );
      }
    } on Exception {
      print("Error al eliminar");
      throw GraphqlServerException(
        "No se pudo eliminar la cuenta, inténtelo más tarde",
      );
    }
  }
}
