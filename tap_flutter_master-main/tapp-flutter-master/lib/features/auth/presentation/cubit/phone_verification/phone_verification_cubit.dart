import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

part 'phone_verification_state.dart';

@injectable
class PhoneVerificationCubit extends Cubit<PhoneVerificationState> {
  final IAuthRepository _repository;
  final AuthCubit _authCubit;
  final ProfileCubit _profileCubit;
  String _phoneNumber = "";

  PhoneVerificationCubit(
    this._repository,
    this._authCubit,
    this._profileCubit,
  ) : super(PhoneVerificationInitial());

  /// Start phone verification with user's phone number
  void startPhoneVerification(String phoneNumber) async {
    emit(PhoneVerificationInProgress());

    _phoneNumber = phoneNumber;

    await _handlePhoneVerification(phoneNumber);
  }

  /// Call repository function to verify phone number,
  /// passing some functions to handle different events.
  Future<void> _handlePhoneVerification(String phoneNumber) async {
    _repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  /// This function is called when Android (only) automatically
  /// validate the SMS code, and generate a phoneAuthCredential
  void _verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    await _linkCredential(phoneAuthCredential);
  }

  /// This function is called when the phone number is incorrect
  /// The state updates to PhoneVerificationFailure
  void _verificationFailed(FirebaseAuthException exception) {
    emit(PhoneVerificationFailure(exception.message!));
  }

  /// This function is triggered when the SMS code has been sent.
  /// The state updates to PhoneVerificationCodeSent
  void _codeSent(String verificationId, [int? resendToken]) {
    emit(PhoneVerificationCodeSent(verificationId));
  }

  /// When the code has been sent, and it wasn't validated automatically,
  /// let the user to enter the code and validate it with this function.
  Future<void> validateSmsCode(String verificationId, String code) async {
    emit(PhoneVerificationInProgress());

    final phoneAuthCredential = _repository.validateSmsCode(
      verificationId: verificationId,
      code: code,
    );
    await _linkCredential(phoneAuthCredential);
  }

  /// This function links the credential auto generated
  /// in _verificationCompleted or _codeSent functions,
  /// and updates state to PhoneVerificationFailure or PhoneVerificationSuccess.
  /// Also, updates user's info with validated phone number
  /// and call authCubit.checkUserAlreadySignedIn to redirect the user
  /// to correct screen.
  Future<void> _linkCredential(AuthCredential phoneAuthCredential) async {
    final credentialLinked =
        await _repository.linkCredentials(phoneAuthCredential);

    await credentialLinked.fold(
      (failure) {
        emit(PhoneVerificationFailure(failure.message));
      },
      (_) async {
        emit(PhoneVerificationSuccess());
        // final uid = (_authCubit.state as MissingInfo).user.uid;
        await _profileCubit.updatePhoneNumber(_phoneNumber);
        await _authCubit.checkSignedInUser();
      },
    );
  }
}
