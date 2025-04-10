import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';
import 'package:tapp/features/notifications/domain/repositories/notifications_repository.dart';

part 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final INotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(NotificationsInitial());

  Future<void> getNotifications(String uid) async {
    if (isClosed) return;
    emit(NotificationsLoadInProgress());

    final result = await _repository.getNotifications(uid);

    if (isClosed) return;
    result.fold(
      (failure) => emit(NotificationsLoadFailure(failure.message)),
      (notifications) => emit(NotificationsLoadSuccess(notifications)),
    );
  }
}
