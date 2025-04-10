part of 'folllow_unfollow_cubit.dart';

abstract class FollowUnfollowState  extends Equatable {
  const FollowUnfollowState();

  @override
  List<Object> get props => [];
}

class FollowUnfollowInitial extends FollowUnfollowState {}

class FollowUnfollowSuccess extends FollowUnfollowState {}

class FollowUnfollowInProgress extends FollowUnfollowState {}

class FollowUnfollowFailure extends FollowUnfollowState {
  final String message;

  const FollowUnfollowFailure(this.message);

  @override
  List<Object> get props => [message];
}