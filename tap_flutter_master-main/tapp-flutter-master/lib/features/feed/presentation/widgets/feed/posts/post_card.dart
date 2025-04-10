import 'package:flutter/material.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_actions.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_content.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_text.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_user_avatar_and_date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final Post _post;

  const PostCard(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PostUserAvatarAndDate(_post),
          PostText(_post.message),
          if (_post.reportCount > 0)
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                color: Colors.grey[200]!,
                border: Border.all(color: Colors.red[300]!, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                AppLocalizations.of(context)!.user_have_report,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            PostContent(_post),
          const Divider(indent: 10, endIndent: 10),
          PostActions(_post),
        ],
      ),
    );
  }
}
