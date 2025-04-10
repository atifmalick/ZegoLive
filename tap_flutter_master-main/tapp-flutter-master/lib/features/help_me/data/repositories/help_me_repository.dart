import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tapp/features/help_me/data/data/graphql_data_source.dart';
import 'package:tapp/features/help_me/domain/repositories/i_help_me_repository.dart';

@LazySingleton(as: IHelpMeRepository)
class HelpMeRepository implements IHelpMeRepository {
  final IHelpMeGraphqlDataSource _graphqlDataSource;

  const HelpMeRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, Unit>> sendHelpMeAlert(
    Map<String, dynamic> data,
  ) async {
    try {
      await _graphqlDataSource.sendHelpMeAlert(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }
}
