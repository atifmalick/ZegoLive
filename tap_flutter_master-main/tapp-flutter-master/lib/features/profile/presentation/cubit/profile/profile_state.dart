part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final TappUser tappUser;

  const ProfileLoadSuccess(this.tappUser);

  @override
  List<Object> get props => [tappUser];
}

class ProfileLoadFailure extends ProfileState {}
