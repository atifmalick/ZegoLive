import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'block_user_state.dart';

@injectable
class BlockUserCubit extends Cubit<BlockUserState> {
  final IFeedRepository _repository;

  BlockUserCubit(this._repository) : super(BlockUserState.initial);

  void blockUser(Map<String, dynamic> data) async {
    emit(BlockUserState.inProgress);

    final result = await _repository.blockUser(data);

    result.fold(
      (failure) => emit(BlockUserState.failure),
      (success) => emit(BlockUserState.success),
    );
  }
}
