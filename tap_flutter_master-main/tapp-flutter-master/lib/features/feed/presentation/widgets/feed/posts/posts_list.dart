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
  bool showOriginatedTime = false;
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
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        if (state is PostsInitial || state is PostsLoadInProgress) {
          return _buildLoadingIndicator();
        } else if (state is PostsLoadSuccess) {
          final liveStreamPosts = state.posts.where((post) {
            return post.isStream && post.creator!.uid != widget.user.uid;
          }).toList();

          final regularPosts = state.posts.where((post) => !post.isStream).toList();

          return Column(
            children: [
              const SizedBox(height: 10),
              if (liveStreamPosts.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: liveStreamPosts.length,
                    itemBuilder: (context, index) {
                      final post = liveStreamPosts[index];
                      final bool isLive = post.isStream && post.isStream;

                      // Hardcode recordingUrl for testing
                      String recordingUrl = post.recordingUrl ?? "";
                      if (post.postId == "67f6827c650bf1b2c993bbf4") {
                        recordingUrl =
                        "https://tapdn.s3.us-east-2.amazonaws.com/Z_aCfsdmzESsCqOW_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_main_VA_20250409142150496.mp4";
                        log("Using hardcoded recordingUrl for ${post.postId}: $recordingUrl");
                      }

                      if (!isLive &&
                          recordingUrl.isNotEmpty &&
                          !_videoControllers.containsKey(post.postId)) {
                        log("Initializing video for ${post.postId} with URL: $recordingUrl");
                        _videoControllers[post.postId] =
                        VideoPlayerController.network(recordingUrl)
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
                              log("Tapped ${post.postId}: isLive=$isLive, recordingUrl=$recordingUrl");
                              if (isLive && post.postId.isNotEmpty) {
                                log("Navigating to live stream for ${post.postId}");
                                _navigateToLiveStream(context, post);
                              } else if (recordingUrl.isNotEmpty && post.postId.isNotEmpty) {
                                log("Playing recording for ${post.postId}");
                                _playRecording(post.copyWith(recordingUrl: recordingUrl));
                              } else {
                                log("No recording URL for ${post.postId}");
                              }
                            },
                            onLongPress: () => _showPostOptions(context, post),
                            child: _buildStreamContent(post, isLive),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              isLive
                                  ? "Streaming Now"
                                  : "Originated at ${_formatDate(post.date)}",
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
              regularPosts.isNotEmpty
                  ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 100),
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

  Widget _buildStreamContent(Post post, bool isLive) {
    // Hardcode recordingUrl for testing
    String recordingUrl = post.recordingUrl ?? "";
    if (post.postId == "67f6827c650bf1b2c993bbf4") {
      recordingUrl =
      "https://tapdn.s3.us-east-2.amazonaws.com/Z_aCfsdmzESsCqOW_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_43a804e7-1ac8-4ca6-80bf-30a7c22489c3_main_VA_20250409142150496.mp4";
      log("Using hardcoded recordingUrl for ${post.postId}: $recordingUrl");
    }

    if (post.postId.isNotEmpty) {
      if (isLive) {
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
        if (!_videoControllers.containsKey(post.postId)) {
          log("Initializing video for ${post.postId} with URL: $recordingUrl");
          _videoControllers[post.postId] = VideoPlayerController.network(recordingUrl)
            ..initialize().then((_) {
              log("Video initialized for ${post.postId}");
              if (mounted) setState(() {});
            }).catchError((error) {
              log("Video initialization failed for ${post.postId}: $error");
            });
        }
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
        } else {
          log("Controller not ready for ${post.postId}: initialized=${controller?.value.isInitialized}");
          return _buildLiveStreamAvatar(post, false);
        }
      }
    }
    return _buildLiveStreamAvatar(post, false);
  }

  Widget _buildLiveStreamAvatar(Post post, bool isLive) {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLive ? Colors.red : Colors.grey,
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

  bool _isStreamLive(int timestamp) {
    final DateTime postDate = DateTime.fromMillisecondsSinceEpoch(timestamp ~/ 1000);
    final int minutesDifference = DateTime.now().difference(postDate).inMinutes;
    return minutesDifference < 10;
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

  void _playRecording(Post post) {
    final controller = _videoControllers[post.postId];
    if (controller != null) {
      if (controller.value.isInitialized) {
        log("Playing video for ${post.postId}");
        controller.play();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.pause();
                  log("Paused video for ${post.postId}");
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ).then((_) {
          controller.pause();
          log("Dialog closed, paused video for ${post.postId}");
        });
      } else {
        log("Video not initialized for ${post.postId}");
      }
    } else {
      log("Controller is null for ${post.postId}");
    }
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