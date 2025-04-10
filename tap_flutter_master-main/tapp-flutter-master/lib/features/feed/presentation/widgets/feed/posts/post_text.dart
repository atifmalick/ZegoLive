import 'package:flutter/material.dart';

class PostText extends StatelessWidget {
  final String postText;

  const PostText(this.postText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (postText.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 10, 10),
        child: Text(
          postText,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
