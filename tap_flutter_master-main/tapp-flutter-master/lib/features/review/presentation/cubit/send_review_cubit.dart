import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/review/domain/repositories/review_repository.dart';

part 'send_review_state.dart';

@injectable
class SendReviewCubit extends Cubit<SendReviewState> {
  final IReviewRepository _repository;

  SendReviewCubit(this._repository) : super(SendReviewInitial());

  void sendReview(Map<String, dynamic> data) async {
    emit(SendReviewInProgress());
    final result = await _repository.sendReview(data);

    // result.fold(
    //   (failure) {
    //     emit(SendReviewFailure(failure.message));
    //   },
    //   (message) {
    //     emit(SendReviewSuccess());
    //   },
    // );
    await result.fold((failure) {
      emit(SendReviewFailure(failure.message));
    }, (dd) async {
      emit(SendReviewSuccess(dd));
    });
  }
}
