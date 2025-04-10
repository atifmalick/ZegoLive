import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'delete_post_state.dart';

@injectable
class DeletePostCubit extends Cubit<DeletePostState> {
  final IFeedRepository _repository;
  DeletePostCubit(this._repository) : super(DeletePostInitial());

  Future<void> deletePost(Map<String, dynamic> data) async {
    emit(DeletePostInProgress());
    final result = await _repository.deletePost(data);
    log(result.toString(), name: "Deleted Post Result");
    result.fold(
      (failure) => emit(DeletePostFailure(failure.message)),
      (success) => emit(DeletePostSuccess()),
    );
  }
}
