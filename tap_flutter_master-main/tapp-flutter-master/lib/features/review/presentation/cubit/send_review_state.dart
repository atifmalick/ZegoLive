part of 'send_review_cubit.dart';

abstract class SendReviewState extends Equatable {
  const SendReviewState();

  @override
  List<Object> get props => [];
}

class SendReviewInitial extends SendReviewState {}

class SendReviewInProgress extends SendReviewState {}

class SendReviewSuccess extends SendReviewState {
  // final Review review;
  final Map<String, dynamic> review;

  const SendReviewSuccess(this.review);

  @override
  List<Object> get props => [review];
}

class SendReviewFailure extends SendReviewState {
  final String message;

  const SendReviewFailure(this.message);

  @override
  List<Object> get props => [message];
}
