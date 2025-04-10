import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final IAuthRepository _repository;

  ResetPasswordBloc(this._repository) : super(ResetPasswordInitial());

  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is ResetPasswordStarted) {
      yield ResetPasswordInProgress();

      final result = await _repository.resetPassword(event.email);

      yield* result.fold(
        (failure) async* {
          yield ResetPasswordFailure(failure.message);
        },
        (success) async* {
          yield ResetPasswordSuccess();
        },
      );
    }
  }
}
