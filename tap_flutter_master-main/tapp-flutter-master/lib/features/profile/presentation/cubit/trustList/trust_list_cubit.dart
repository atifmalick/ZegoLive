import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'trust_list_state.dart';

@injectable
class TrustListCubit extends Cubit<TrustListState> {
  final IProfileRepository _repository;

  TrustListCubit(this._repository) : super(TrustListInitial());

  Future<void> getTrustList(String uid) async {
    if (isClosed) return;
    emit(TrustListLoadInProgress());

    final result = await _repository.getTrustList(uid);

    if (isClosed) return;
    result.fold(
      (failure) => emit(TrustListLoadFailure(failure.message)),
      (users) => emit(TrustListLoadSuccess(users)),
    );
  }
}
