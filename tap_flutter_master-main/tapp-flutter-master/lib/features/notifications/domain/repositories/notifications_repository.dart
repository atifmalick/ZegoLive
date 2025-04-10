import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';

typedef NotificationHandler = Future<dynamic> Function(
    Map<String, dynamic> data);

abstract class INotificationsRepository {
  Future<Either<Failure, List<TappNotification>>> getNotifications(String uid);
  Future<Either<Failure, Unit>> reportUser(Map<String, dynamic> data);
}
