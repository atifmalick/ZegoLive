import 'package:flutter/material.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/audio_player_feed.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_image.dart';

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (post.content.type) {
      case ContentType.image:
        return PostImage(post.content.url!);
      case ContentType.audio:
        return MyAudioFeed(url: post.content.url!);
      // return PostAudio(post.content.url);
      // break;
      default:
        return const SizedBox();
    }
  }
}
