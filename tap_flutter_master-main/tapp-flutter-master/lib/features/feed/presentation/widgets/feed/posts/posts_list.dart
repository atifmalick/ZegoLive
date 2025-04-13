import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/presentation/cubit/posts/posts_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/empty_posts.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_block_user_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_card.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_delete_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_report_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_share_option.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/screens/streaming_page.dart';
import 'package:video_player/video_player.dart';
import '../../../../domain/entities/post.dart';

class PostsList extends StatefulWidget {
  final TappUser user;

  const PostsList(this.user, {Key? key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  Timer? _timer;
  Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _startLiveStatusChecker();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _startLiveStatusChecker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); // Refresh UI based on time and state changes
      }
    });
  }

  bool _isWithin20Hours(int timestamp) {
    final DateTime postDate = DateTime.fromMillisecondsSinceEpoch(timestamp ~/ 1000);
    final Duration difference = DateTime.now().difference(postDate);
    return difference.inHours < 24; // True if less than 20 hours old
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        if (state is PostsInitial || state is PostsLoadInProgress) {
          return _buildLoadingIndicator();
        } else if (state is PostsLoadSuccess) {
          final liveStreamPosts = state.posts.where((post) {
            return post.isStream &&
                post.creator!.uid != widget.user.uid &&
                _isWithin20Hours(post.date);
          }).toList();

          final regularPosts = state.posts.where((post) => !post.isStream).toList();

          return Column(
            children: [
              if (liveStreamPosts.isNotEmpty) ...[
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: liveStreamPosts.length,
                    itemBuilder: (context, index) {
                      final post = liveStreamPosts[index];
                      final bool isStreamLive = post.isStream && (post.recordingUrl == null || post.recordingUrl!.isEmpty);
                      final String recordingUrl = post.recordingUrl ?? "";

                      if (!isStreamLive && recordingUrl.isNotEmpty && !_videoControllers.containsKey(post.postId)) {
                        log("Initializing video for ${post.postId} with URL: $recordingUrl");
                        _videoControllers[post.postId] = VideoPlayerController.network(recordingUrl)
                          ..initialize().then((_) {
                            log("Video initialized for ${post.postId}");
                            if (mounted) setState(() {});
                          }).catchError((error) {
                            log("Video initialization failed for ${post.postId}: $error");
                          });
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              log("Tapped ${post.postId}: isStreamLive=$isStreamLive, recordingUrl=$recordingUrl");
                              if (isStreamLive) {
                                log("Navigating to live stream for ${post.postId}");
                                _navigateToLiveStream(context, post);
                              } else if (recordingUrl.isNotEmpty) {
                                log("Navigating to recording playback for ${post.postId}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlaybackScreen(post: post),
                                  ),
                                );
                              } else {
                                log("No recording URL and not live for ${post.postId}, defaulting to live stream");
                                _navigateToLiveStream(context, post);
                              }
                            },
                            onLongPress: () => _showPostOptions(context, post),
                            child: _buildStreamContent(post, isStreamLive),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              _formatDate(post.date),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5), // Reduced from 10 to 5
              ],
              regularPosts.isNotEmpty
                  ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 5), // Reduced from 100 to 5
                shrinkWrap: true,
                itemCount: regularPosts.length,
                itemBuilder: (context, i) {
                  return PostCard(regularPosts[i]);
                },
              )
                  : const EmptyPosts(),
            ],
          );
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      alignment: Alignment.center,
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.black),
        ),
      ),
    );
  }

  Widget _buildStreamContent(Post post, bool isStreamLive) {
    final String recordingUrl = post.recordingUrl ?? "";
    if (post.postId.isNotEmpty) {
      if (isStreamLive) {
        return Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1.5),
          ),
          child: CachedNetworkImage(
            imageUrl: post.creator!.profilePicture?.url.toString() ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => _buildFallbackAvatar(post),
          ),
        );
      } else if (recordingUrl.isNotEmpty) {
        final controller = _videoControllers[post.postId];
        if (controller != null && controller.value.isInitialized) {
          return Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1.5),
            ),
            child: ClipOval(
              child: VideoPlayer(controller),
            ),
          );
        }
      }
    }
    return _buildLiveStreamAvatar(post, false);
  }

  Widget _buildLiveStreamAvatar(Post post, bool isStreamLive) {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isStreamLive ? Colors.red : Colors.grey,
          width: 1.5,
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: post.creator!.profilePicture?.url.toString() ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => _buildFallbackAvatar(post),
      ),
    );
  }

  Widget _buildFallbackAvatar(Post post) {
    return Center(
      child: Text(
        (post.creator!.username ?? "C").substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp ~/ 1000);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  void _navigateToLiveStream(BuildContext context, Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LivePage(
          executeFunction: false,
          liveStremId: "${widget.user.username}-liveStream",
          userId: widget.user.uid.toString(),
          username: widget.user.username.toString(),
          liveID: post.message,
          isHost: false,
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          enableDrag: false,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          onClosing: () {},
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SharePostOption(post),
                PostBlockUserOption(post),
                PostReportOption(post),
                PostDeleteOption(post),
              ],
            );
          },
        );
      },
    );
  }
}

class VideoPlaybackScreen extends StatefulWidget {
  final Post post;

  const VideoPlaybackScreen({Key? key, required this.post}) : super(key: key);

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.recordingUrl!)
      ..initialize().then((_) {
        log("Video initialized for playback: ${widget.post.postId}");
        _controller.play();
        setState(() {});
      }).catchError((error) {
        log("Failed to initialize video for playback: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recording Playback"),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}