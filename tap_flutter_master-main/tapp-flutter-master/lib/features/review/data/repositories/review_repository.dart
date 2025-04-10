import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/review/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/review/domain/repositories/review_repository.dart';

import '../../domain/repositories/review_repository.dart';

@Injectable(as: IReviewRepository)
class ReviewRepository implements IReviewRepository {
  final IReviewGraphqlDataSource _graphqlDataSource;

  ReviewRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendReview(
      Map<String, dynamic> data) async {
    try {
      final message = await _graphqlDataSource.sendReview(data);

      return right(message);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }
}
