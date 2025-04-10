import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tapp/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final IAuthRepository _repository;
  final SignInCubit _signInCubit;

  SignUpCubit(
    this._repository,
    this._signInCubit,
  ) : super(SignUpInitial());

  /// Sign up user and return success or failure messages.
  /// If sign up succeded, call signInCubit.signInWithEmailAndPassword()
  /// to sign In immediately and redirect the user to correct screen.
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    emit(SignUpInProgress());

    final result = await _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.fold(
      (failure) {
        emit(SignUpFailure(failure.message));
      },
      (_) async {
        emit(SignUpSuccess());
        await _signInCubit.signInWithEmailAndPassword(email, password);
      },
    );
  }
}
