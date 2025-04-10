import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/following/following_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/following/unfollow_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnfollowUserOption extends StatelessWidget {
  final TappUser _user;

  const UnfollowUserOption(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    return BlocListener<UnfollowUserCubit, UnfollowUserState>(
      listener: (context, state) {
        if (state is UnfollowUserInProgress) {
          SnackbarHelper.infoSnackbar(
                  AppLocalizations.of(context)!.unfollowing_user)
              .show(context);
        }

        if (state is UnfollowUserSuccess) {
          SnackbarHelper.successSnackbar(
                  AppLocalizations.of(context)!.you_have_unfollow)
              .show(context);
          context.read<FollowingCubit>().followingUsers(user.uid!);
        }

        if (state is UnfollowUserFailure) {
          SnackbarHelper.failureSnackbar(
                  AppLocalizations.of(context)!.error_occur, state.message)
              .show(context);
        }
      },
      child: SizedBox(
        height: 50,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SlidableAction(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                label: "Unfollow",
                icon: Icons.person_remove,
                onPressed: (_) {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context)!.stop_following),
                          content: Text(
                            "${AppLocalizations.of(context)!.you_will_stop_following} ${_user.username}.",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  textStyle:
                                      TextStyle(color: AppColors.purple)),
                              child: Text(AppLocalizations.of(context)!.cancel),
                              onPressed: () => getIt<NavigationService>().pop(),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle:
                                        TextStyle(color: AppColors.purple)),
                                child: Text(AppLocalizations.of(context)!
                                    .stop_following),
                                onPressed: () {
                                  final unfollowCount =
                                      (user.followingCount ?? 0) - 1;
                                  final unfollowing = (user.following ?? [])
                                      .where((element) => element != _user.uid!)
                                      .map<String>((e) => e)
                                      .toList();
                                  // print(unfollowing);
                                  final userUpdate = {
                                    ...user.toJson(),
                                    'followingCount': unfollowCount,
                                    'following': unfollowing
                                  };
                                  // print(userUpdate);
                                  // print(_user.uid);
                                  context
                                      .read<ProfileCubit>()
                                      .updateUserState(userUpdate);

                                  context
                                      .read<UnfollowUserCubit>()
                                      .unfollowUser(_user.uid!);

                                  // context
                                  //     .read<FollowingCubit>()
                                  //     .followingUsers(_user.uid!);
                                  getIt<NavigationService>().pop();
                                  getIt<NavigationService>()
                                      .navigateToAndReplace(
                                          Routes.followingUsers);
                                }),
                          ],
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
