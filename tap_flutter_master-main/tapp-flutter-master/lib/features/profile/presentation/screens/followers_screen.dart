import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/followers_cubit/following_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/followers/empty_users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowersScreen extends StatelessWidget {
  final _followersListCubit = getIt<FollowersCubit>();

  FollowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<ProfileCubit>().state as ProfileLoadSuccess)
        .tappUser
        .uid;

    return BlocProvider<FollowersCubit>(
      create: (context) => _followersListCubit..followingUsers(uid!),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.follower,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocBuilder<FollowersCubit, FollowersState>(
            builder: (context, state) {
          if (state is FollowersInitialState || state is FollowersInProgress) {
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.black),
                ),
              ),
            );
          } else if (state is FollowersSuccess) {
            return state.users.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    itemBuilder: (context, i) {
                      TappUser user = state.users[i];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          leading: CustomCircleAvatar(
                            backgroundColor: AppColors.purple,
                            url: user.profilePicture?.url,
                            fallbackTextSize: 16,
                            fallbackText: user.username ?? 'User',
                            radius: 20,
                          ),
                          title: Text(
                            "${user.username}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${user.description}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context2) {
                                      return AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .unfollower),
                                        content: Text(
                                          "${AppLocalizations.of(context)!.you_will_stop_follow} ${user.username}.",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                textStyle: TextStyle(
                                                    color: AppColors.purple)),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel),
                                            onPressed: () =>
                                                getIt<NavigationService>()
                                                    .pop(),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  textStyle: TextStyle(
                                                      color: AppColors.purple)),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .stop_following),
                                              onPressed: () {
                                                final unfollowCount =
                                                    (user.followingCount ?? 0) -
                                                        1;
                                                final unfollowing = (user
                                                            .followers ??
                                                        [])
                                                    .where((element) =>
                                                        element != user.uid!)
                                                    .map<String>((e) => e)
                                                    .toList();

                                                final userUpdate = {
                                                  ...user.toJson(),
                                                  'followerCount':
                                                      unfollowCount,
                                                  'followers': unfollowing
                                                };

                                                // context
                                                //     .read<ProfileCubit>()
                                                //     .updateUserState(
                                                //         userUpdate);

                                                context
                                                    .read<FollowersCubit>()
                                                    .removeFolloweUser(
                                                        user.uid!);

                                                getIt<NavigationService>()
                                                    .pop();
                                              }),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.minimize,
                                color: Colors.black,
                              )),
                        ),
                      );

                      // Column(
                      //   children: [
                      //     // BlocBuilder<RemoveFolloweUserCubit,
                      //     //     RemoveFollowerUserState>(
                      //     // builder: (context, state) {
                      //     // return
                      //     FollowersUserTile(user)
                      //     // },
                      //     // )
                      //   ],
                      // );
                    },
                    separatorBuilder: (context, i) {
                      return const Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1.5,
                      );
                    },
                    itemCount: state.users.length,
                  )
                : const EmptyUsers();
          } else {
            print(state);
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
