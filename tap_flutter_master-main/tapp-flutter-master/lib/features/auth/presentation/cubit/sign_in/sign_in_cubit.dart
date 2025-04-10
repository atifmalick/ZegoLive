import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final IAuthRepository _repository;
  final AuthCubit _authCubit;

  SignInCubit(
    this._repository,
    this._authCubit,
  ) : super(SignInInitial());

  /// Sign in an user and return success or failure messages.
  /// If sign in succeded, call authCubit.checkUserAlreadySignedIn()
  /// to redirect the user to correct screen.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(SignInInProgress());

    final result = await _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.fold(
      (failure) {
        emit(SignInFailure(failure.message));
      },
      (_) async {
        emit(SignInSuccess());
        await _authCubit.checkSignedInUser();
      },
    );
  }
}
