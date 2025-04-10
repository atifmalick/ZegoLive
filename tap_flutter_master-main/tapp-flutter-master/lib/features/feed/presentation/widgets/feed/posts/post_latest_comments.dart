import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';

class PostLatestComments extends StatelessWidget {
  final Post post;

  const PostLatestComments(this.post, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: post.comments.map((comment) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomCircleAvatar(
                    backgroundColor: AppColors.purple,
                    url: '',
                    fallbackText: comment.username,
                    fallbackTextSize: 12,
                    radius: 16,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text(
                      comment.message,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
