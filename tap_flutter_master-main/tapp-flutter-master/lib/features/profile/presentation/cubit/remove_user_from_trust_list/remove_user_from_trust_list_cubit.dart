import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'remove_user_from_trust_list_state.dart';

@injectable
class RemoveUserFromTrustListCubit extends Cubit<RemoveUserFromTrustListState> {
  final IProfileRepository _repository;

  RemoveUserFromTrustListCubit(this._repository)
      : super(RemoveUserFromTrustListInitial());

  Future<void> removeUserFromTrustList(Map<String, dynamic> data) async {
    emit(RemoveUserFromTrustListInProgress());

    final result = await _repository.removeUserFromTrustList(data);

    result.fold(
      (failure) => emit(RemoveUserFromTrustListFailure(failure.message)),
      (success) => emit(RemoveUserFromTrustListSuccess()),
    );
  }
}
