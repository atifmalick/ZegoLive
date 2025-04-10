import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';

abstract class IHelpMeRepository {
  /// Send Help Me alert to nearby users
  Future<Either<Failure, Unit>> sendHelpMeAlert(Map<String, dynamic> data);
}
