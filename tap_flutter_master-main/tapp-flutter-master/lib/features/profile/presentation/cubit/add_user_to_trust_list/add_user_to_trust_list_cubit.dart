import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'add_user_to_trust_list_state.dart';

@injectable
class AddUserToTrustListCubit extends Cubit<AddUserToTrustListState> {
  final IProfileRepository _repository;

  AddUserToTrustListCubit(this._repository)
      : super(AddUserToTrustListInitial());

  Future<void> addUserToTrustList(Map<String, dynamic> data) async {
    emit(AddUserToTrustListInProgress());

    final result = await _repository.addUserToTrustList(data);

    result.fold(
      (failure) => emit(AddUserToTrustListFailure(failure.message)),
      (success) => emit(AddUserToTrustListSuccess()),
    );
  }
}
