part of 'add_user_to_trust_list_cubit.dart';

abstract class AddUserToTrustListState extends Equatable {
  const AddUserToTrustListState();

  @override
  List<Object> get props => [];
}

class AddUserToTrustListInitial extends AddUserToTrustListState {}

class AddUserToTrustListInProgress extends AddUserToTrustListState {}

class AddUserToTrustListSuccess extends AddUserToTrustListState {}

class AddUserToTrustListFailure extends AddUserToTrustListState {
  final String message;

  const AddUserToTrustListFailure(this.message);

  @override
  List<Object> get props => [message];
}
