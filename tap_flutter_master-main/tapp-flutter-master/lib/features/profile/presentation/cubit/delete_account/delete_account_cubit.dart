import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';

part 'delete_account_state.dart';

@injectable
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final IAuthRepository _repository;
  final String securityWord = "eliminar";

  DeleteAccountCubit(this._repository) : super(DeleteAccountInitial());

  Future<void> deleteAccount() async {
    emit(DeleteAccountInProgress());
    final result = await _repository.deleteAccount();

    result.fold(
      (failure) => emit(DeleteAccountFailure(failure.message)),
      (success) => emit(DeleteAccountSuccess()),
    );
  }
}
