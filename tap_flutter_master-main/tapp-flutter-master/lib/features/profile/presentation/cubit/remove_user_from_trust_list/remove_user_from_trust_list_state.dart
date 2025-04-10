part of 'remove_user_from_trust_list_cubit.dart';

abstract class RemoveUserFromTrustListState extends Equatable {
  const RemoveUserFromTrustListState();

  @override
  List<Object> get props => [];
}

class RemoveUserFromTrustListInitial extends RemoveUserFromTrustListState {}

class RemoveUserFromTrustListInProgress extends RemoveUserFromTrustListState {}

class RemoveUserFromTrustListSuccess extends RemoveUserFromTrustListState {}

class RemoveUserFromTrustListFailure extends RemoveUserFromTrustListState {
  final String message;

  const RemoveUserFromTrustListFailure(this.message);

  @override
  List<Object> get props => [message];
}
