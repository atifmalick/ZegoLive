import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/notifications/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';
import 'package:tapp/features/notifications/domain/repositories/notifications_repository.dart';

@LazySingleton(as: INotificationsRepository)
class NotificationsRepository implements INotificationsRepository {
  final INotificationsGraphqlDataSource _graphqlDataSource;

  NotificationsRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, List<TappNotification>>> getNotifications(String uid) async {
    try {
      final notifications = await _graphqlDataSource.getNotifications(uid);
      return right(notifications);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> reportUser(Map<String, dynamic> data) async {
    try {
      await _graphqlDataSource.reportUser(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }
}
