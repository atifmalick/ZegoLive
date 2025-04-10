part of 'following_cubit.dart';

abstract class FollowingState extends Equatable {
  const FollowingState();

  @override
  List<Object> get props => [];
}

class FollowingInitialState extends FollowingState {}

class FollowingInProgress extends FollowingState {}

class FollowingSuccess extends FollowingState {
  final List<TappUser> users;

  const FollowingSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class FollowingFailure extends FollowingState {
  final String message;

  const FollowingFailure(this.message);

  @override
  List<Object> get props => [message];
}
