part of 'following_cubit.dart';

abstract class FollowersState extends Equatable {
  const FollowersState();

  @override
  List<Object> get props => [];
}

class FollowersInitialState extends FollowersState {}

class FollowersInProgress extends FollowersState {}

class FollowersSuccess extends FollowersState {
  final List<TappUser> users;

  const FollowersSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class FollowersFailure extends FollowersState {
  final String message;

  const FollowersFailure(this.message);

  @override
  List<Object> get props => [message];
}
