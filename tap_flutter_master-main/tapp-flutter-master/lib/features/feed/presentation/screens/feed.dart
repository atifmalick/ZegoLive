import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/presentation/cubit/posts/posts_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/feed_header.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/posts_list.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  final _postsCubit = getIt<PostsCubit>();

  @override
  void dispose() {
    _postsCubit.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadSuccess) {
          return BlocProvider<PostsCubit>(
            create: (context) => _postsCubit..getPosts(state.tappUser.uid!),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  await _postsCubit.getPosts(state.tappUser.uid!);
                },
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    FeedHeader(state.tappUser),
                    PostsList(state.tappUser),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        }
      },
    );
  }
}
