import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'report_post_state.dart';

@injectable
class ReportPostCubit extends Cubit<ReportPostState> {
  final IFeedRepository _repository;

  ReportPostCubit(this._repository) : super(ReportPostState.initial);

  void reportPost(Map<String, dynamic> data) async {
    emit(ReportPostState.inProgress);

    final result = await _repository.reportPost(data);

    result.fold(
      (failure) => emit(ReportPostState.failure),
      (success) => emit(ReportPostState.success),
    );
  }
}
