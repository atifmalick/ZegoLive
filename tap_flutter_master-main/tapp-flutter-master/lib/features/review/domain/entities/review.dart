import 'package:equatable/equatable.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class Review extends Equatable {
  final TappUser userId;
  final String subject;
  final String message;

  const Review({
    required this.userId,
    required this.subject,
    required this.message,
  });

  Review copyWith({String? message}) {
    return Review(userId: userId, subject: subject, message: message ?? '');
  }

  @override
  List<Object> get props => [userId, subject, message];
}
