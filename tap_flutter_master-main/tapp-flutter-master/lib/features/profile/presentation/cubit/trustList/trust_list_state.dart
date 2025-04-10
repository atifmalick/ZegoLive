part of 'trust_list_cubit.dart';

abstract class TrustListState extends Equatable {
  const TrustListState();

  @override
  List<Object> get props => [];
}

class TrustListInitial extends TrustListState {}

class TrustListLoadInProgress extends TrustListState {}

class TrustListLoadSuccess extends TrustListState {
  final List<TappUser> users;

  const TrustListLoadSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class TrustListLoadFailure extends TrustListState {
  final String message;

  const TrustListLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
