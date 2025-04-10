import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/follow_unfollow/folllow_unfollow_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_block_user_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_delete_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_report_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_share_option.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_user_verified.dart';
import 'package:tapp/features/profile/presentation/cubit/following/unfollow_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostUserAvatarAndDate extends StatelessWidget {
  final Post _post;

  const PostUserAvatarAndDate(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    final followingUser = (user.following ?? [])
        .firstWhereOrNull((element) => element == _post.creator!.uid);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: CustomCircleAvatar(
              backgroundColor: AppColors.purple,
              url: _post.creator?.profilePicture?.url,
              fallbackTextSize: 16,
              fallbackText: _post.creator!.username!,
              radius: 20,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              _post.creator!.username!.length > 12
                                  ? '${_post.creator!.username!.substring(0, 12)}...'
                                  : _post.creator!.username!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _post.creator!.isRegionalAlly!,
                            child: const Flexible(child: PostUserVerified()),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _post.creator!.verified!,
                      child: Tooltip(
                        message: AppLocalizations.of(context)!.regional_account,
                        preferBelow: false,
                        child: Icon(
                          Icons.verified,
                          size: 30,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                    if ((followingUser == null)) ...[
                      BlocBuilder<FollowUnfollowCubit, FollowUnfollowState>(
                          builder: (_, state) {
                        return Visibility(
                            visible: _post.creator!.verified!,
                            child: Expanded(
                              child: ButtonFollow(
                                  title: AppLocalizations.of(context)!.follow,
                                  onPressed: () {
                                    final followCount =
                                        (user.followingCount ?? 0) + 1;
                                    final following = [
                                      ...(user.following ?? []),
                                      _post.creator!.uid!
                                    ].map<String>((e) => e).toList();

                                    final userUpdate = {
                                      ...user.toJson(),
                                      'followingCount': followCount,
                                      'following': following
                                    };

                                    context
                                        .read<FollowUnfollowCubit>()
                                        .followUSer(_post.creator!.uid!);
                                    context
                                        .read<ProfileCubit>()
                                        .updateUserState(userUpdate);
                                  }),
                            ));
                      }),
                    ],
                    if ((followingUser != null)) ...[
                      BlocBuilder<UnfollowUserCubit, UnfollowUserState>(
                          builder: (context, state) {
                        return Expanded(
                          child: ButtonFollow(
                              title: AppLocalizations.of(context)!.following,
                              onPressed: () {
                                final unfollowCount =
                                    (user.followingCount ?? 0) - 1;
                                final unfollowing = (user.following ?? [])
                                    .where((element) =>
                                        element != _post.creator!.uid!)
                                    .map<String>((e) => e)
                                    .toList();

                                final userUpdate = {
                                  ...user.toJson(),
                                  'followingCount': unfollowCount,
                                  'following': unfollowing
                                };

                                context
                                    .read<UnfollowUserCubit>()
                                    .unfollowUser(_post.creator!.uid!);
                                context
                                    .read<ProfileCubit>()
                                    .updateUserState(userUpdate);
                              }),
                        );
                      }),
                    ]
                  ],
                ),
                Text(
                  DateHelper.longDateWithTime(int.parse(_post.date
                      .toString()
                      .substring(0, _post.date.toString().length - 3))),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 360 ? 12 : 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: SharePostOption(_post)),
                              // Flexible(child: PostSendMessageOption(_post)),
                              Flexible(child: PostBlockUserOption(_post)),
                              Flexible(child: PostReportOption(_post)),
                              Flexible(child: PostDeleteOption(_post))
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingFollow extends StatelessWidget {
  const LoadingFollow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .06,
      height: MediaQuery.of(context).size.width * .06,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
      ),
    );
  }
}

class ButtonFollow extends StatelessWidget {
  final String title;
  final Function()? onPressed;

  const ButtonFollow({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .02),
      height: MediaQuery.of(context).size.width * 0.05,
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.purple,
            fontSize: 12,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                color: AppColors.purple,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
