import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';

abstract class IReviewRepository {
  Future<Either<Failure, Map<String, dynamic>>> sendReview(
    Map<String, dynamic> data,
  );
}
