part of 'unfollow_cubit.dart';

abstract class UnfollowUserState extends Equatable {
  const UnfollowUserState();

  @override
  List<Object> get props => [];
}

class UnfollowUserInitialState extends UnfollowUserState {}

class UnfollowUserInProgress extends UnfollowUserState {}

class UnfollowUserSuccess extends UnfollowUserState {}

class UnfollowUserFailure extends UnfollowUserState {
  final String message;

  const UnfollowUserFailure(this.message);

  @override
  List<Object> get props => [message];
}
