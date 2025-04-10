part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class MissingInfo extends AuthState {
  final User user;
  final String redirectTo;

  const MissingInfo(this.user, {required this.redirectTo});

  @override
  List<Object> get props => [user, redirectTo];
}

class Unauthenticated extends AuthState {}

class OnboardingNotViewed extends AuthState {}
