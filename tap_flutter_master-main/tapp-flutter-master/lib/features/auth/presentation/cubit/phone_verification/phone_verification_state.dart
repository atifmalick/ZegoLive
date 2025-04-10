part of 'phone_verification_cubit.dart';

abstract class PhoneVerificationState extends Equatable {
  const PhoneVerificationState();

  @override
  List<Object> get props => [];
}

class PhoneVerificationInitial extends PhoneVerificationState {}

class PhoneVerificationInProgress extends PhoneVerificationState {}

class PhoneVerificationSuccess extends PhoneVerificationState {}

class PhoneVerificationFailure extends PhoneVerificationState {
  final String message;
  const PhoneVerificationFailure(this.message);
  @override
  List<Object> get props => [message];
}

class PhoneVerificationCodeSent extends PhoneVerificationState {
  final String verificationId;

  const PhoneVerificationCodeSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}
