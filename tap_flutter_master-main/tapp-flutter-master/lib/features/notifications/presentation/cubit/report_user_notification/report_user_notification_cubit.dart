import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/notifications/domain/repositories/notifications_repository.dart';

part 'report_user_notification_state.dart';

@injectable
class ReportUserNotificationCubit extends Cubit<ReportUserNotificationState> {
  final INotificationsRepository _repository;

  ReportUserNotificationCubit(this._repository)
      : super(ReportUserNotificationState.initial);

  void reportUserNotification(Map<String, dynamic> data) async {
    emit(ReportUserNotificationState.inProgress);

    final result = await _repository.reportUser(data);

    result.fold(
      (failure) => emit(ReportUserNotificationState.failure),
      (success) => emit(ReportUserNotificationState.success),
    );
  }
}
