import 'package:tapp/features/review/domain/entities/review.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required TappUser userId,
    required String subject,
    required String message,
  }) : super(userId: userId, subject: subject, message: message);

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        userId: json['userId'] ?? '',
        subject: json['subject'] ?? '',
        message: json['message'] ?? '');
  }
}
