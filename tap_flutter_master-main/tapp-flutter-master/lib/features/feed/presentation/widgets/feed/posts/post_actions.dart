import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/navigation/screen_arguments.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/follow_unfollow/folllow_unfollow_cubit.dart';
import 'package:tapp/features/feed/presentation/cubit/like_dislike/like_dislike_cubit.dart';
import 'package:tapp/features/feed/presentation/cubit/posts/posts_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

class PostActions extends StatelessWidget {
  final Post _post;
  final _likesCubit = getIt<LikeDislikeCubit>();
  final user = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

  PostActions(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikeDislikeCubit>(
      create: (context) => _likesCubit,
      child: BlocListener<LikeDislikeCubit, LikeDislikeState>(
        bloc: _likesCubit,
        listener: (context, state) {
          // When like or dislike success, update the post immediately
          if (state is LikeDislikeSuccess) {
            context.read<PostsCubit>().replacePost(state.post);
          }
        },
        child: Row(
          mainAxisAlignment: _post.reportCount == 0
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          children: [
            Visibility(
              visible: _post.creator!.isRegionalAlly!,
              child: Flexible(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: _followUnfollowUser(),
                ),
              ),
            ),
            Visibility(
              visible: _post.reportCount == 0,
              child: Flexible(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: _buildLikeDislikeButton(context),
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: _buildCommentsButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _followUnfollowUser() {
    Color followColor = AppColors.grey;
    String follow = "Seguir";

    return BlocListener<FollowUnfollowCubit, FollowUnfollowState>(
      listener: (context, state) {
        if (state is FollowUnfollowSuccess) {
          SnackbarHelper.successSnackbar(
                  AppLocalizations.of(context)!.you_follow_this_user)
              .show(context);
        }

        if (state is FollowUnfollowFailure) {
          SnackbarHelper.failureSnackbar(
                  AppLocalizations.of(context)!.error_occur,
                  AppLocalizations.of(context)!.you_cannot_follow_user)
              .show(context);
        }
      },
      child: BlocBuilder<FollowUnfollowCubit, FollowUnfollowState>(
        builder: (context, state) {
          if (state is FollowUnfollowInProgress) {
            SnackbarHelper.infoSnackbar(AppLocalizations.of(context)!.following)
                .show(context);
          }
          return ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: followColor,
                elevation: 0,
                backgroundColor: AppColors.white,
              ),
              label: Text(
                follow,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
                ),
              ),
              icon: Icon(Icons.add_box,
                  size: MediaQuery.of(context).size.width > 600 ? 20 : 16),
              onPressed: () {
                final followCount = (user.followingCount ?? 0) + 1;
                final following = [
                  ...(user.following ?? []),
                  _post.creator!.uid
                ].map<String>((e) => e!).toList();

                final userUpdate = {
                  ...user.toJson(),
                  'followingCount': followCount,
                  'following': following
                };

                context
                    .read<FollowUnfollowCubit>()
                    .followUSer(_post.creator!.uid!);
                context.read<ProfileCubit>().updateUserState(userUpdate);
              });
        },
      ),
    );
  }

  Widget _buildLikeDislikeButton(BuildContext context) {
    Color textColor = AppColors.grey;
    String buttonText = 'Me gusta';

    if (_post.likes.contains(user.uid)) {
      textColor = AppColors.red;
      buttonText = '${_post.likes.length} $buttonText';
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      icon: Icon(
        Icons.favorite,
        size: MediaQuery.of(context).size.width > 600 ? 20 : 16,
      ),
      label: Text(
        buttonText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
        ),
      ),
      onPressed: () => _likesCubit.likeUnlikePost(_post, user.uid!),
    );
  }

  Widget _buildCommentsButton(BuildContext context) {
    int comments = _post.comments.length;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[600],
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      icon: Icon(Icons.chat_bubble_rounded,
          size: MediaQuery.of(context).size.width > 600 ? 20 : 16),
      label: Text(
        '$comments ${AppLocalizations.of(context)!.comments}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
        ),
      ),
      onPressed: () {
        getIt<NavigationService>().navigateTo(
          Routes.postCommentsScreen,
          PostCommentsScreenArgs(
            _post.postId,
            _post.creator!.uid!,
            user.uid!,
          ),
        );
      },
    );
  }
}
