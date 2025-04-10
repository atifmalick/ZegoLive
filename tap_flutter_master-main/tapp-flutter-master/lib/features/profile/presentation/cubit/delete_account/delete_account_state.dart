part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountInProgress extends DeleteAccountState {}

class DeleteAccountFailure extends DeleteAccountState {
  final String message;

  const DeleteAccountFailure(this.message);

  @override
  List<Object> get props => [message];
}
