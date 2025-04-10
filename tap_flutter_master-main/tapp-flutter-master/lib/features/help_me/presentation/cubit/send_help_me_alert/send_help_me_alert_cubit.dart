import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/help_me/domain/repositories/i_help_me_repository.dart';

part 'send_help_me_alert_state.dart';

@injectable
class SendHelpMeAlertCubit extends Cubit<SendHelpMeAlertState> {
  final IHelpMeRepository _repository;

  SendHelpMeAlertCubit(this._repository) : super(SendHelpMeAlertInitial());

  void sendHelpMeAlert(Map<String, dynamic> data) async {
    if (isClosed) return;

    emit(SendHelpMeAlertInProgress());

    final result = await _repository.sendHelpMeAlert(data);

    if (isClosed) return;
    result.fold(
      (failure) => emit(SendHelpMeAlertFailure(failure.message)),
      (success) => emit(SendHelpMeAlertSuccess()),
    );
  }
}
