import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tapp/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final IAuthRepository _repository;
  final AuthCubit _authCubit;

  ResetPasswordCubit(
    this._repository,
    this._authCubit,
  ) : super(ResetPasswordInitial());

  /// Sign in an user and return success or failure messages.
  /// If sign in succeded, call authCubit.checkUserAlreadySignedIn()
  /// to redirect the user to correct screen.
  Future<void> resetPasswordWithEmail(String email) async {
    emit(ResetPasswordInProgress());

    final result = await _repository.resetPassword(email);
    await result.fold(
      (failure) {
        emit(ResetPasswordFailure(failure.message));
      },
      (_) async {
        emit(ResetPasswordSuccess());
      },
    );
  }
}
