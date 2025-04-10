part of 'update_profile_cubit.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileInProgress extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final TappUser user;

  const UpdateProfileSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateProfileFailure extends UpdateProfileState {
  final String message;

  const UpdateProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}
