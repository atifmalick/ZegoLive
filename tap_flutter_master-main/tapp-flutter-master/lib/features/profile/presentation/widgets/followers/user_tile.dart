import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/followers_cubit/following_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/service_locator/init_service_locator.dart';

class FollowersUserTile extends StatelessWidget {
  final TappUser _user;

  const FollowersUserTile(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    return BlocBuilder<FollowersCubit, FollowersState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            leading: CustomCircleAvatar(
              backgroundColor: AppColors.purple,
              url: _user.profilePicture?.url,
              fallbackTextSize: 16,
              fallbackText: _user.username ?? 'User',
              radius: 20,
            ),
            title: Text(
              "${_user.username}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${_user.description}",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: IconButton(
                onPressed: () {
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
                                  final unfollowing = (user.followers ?? [])
                                      .where((element) => element != _user.uid!)
                                      .map<String>((e) => e)
                                      .toList();

                                  final userUpdate = {
                                    ...user.toJson(),
                                    'followerCount': unfollowCount,
                                    'followerss': unfollowing
                                  };
                                  context
                                      .read<ProfileCubit>()
                                      .updateUserState(userUpdate);

                                  context
                                      .read<FollowersCubit>()
                                      .removeFolloweUser(_user.uid!);

                                  getIt<NavigationService>().pop();
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
      },
    );
  }
}
