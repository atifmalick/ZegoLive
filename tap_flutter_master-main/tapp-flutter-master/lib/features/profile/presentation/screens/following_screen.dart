import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/following/following_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/following/empty_users.dart';
import 'package:tapp/features/profile/presentation/widgets/following/user_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowingScreen extends StatelessWidget {
  final _followingListCubit = getIt<FollowingCubit>();

  FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<ProfileCubit>().state as ProfileLoadSuccess)
        .tappUser
        .uid;

    return BlocProvider<FollowingCubit>(
      create: (context) => _followingListCubit..followingUsers(uid!),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.following,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocBuilder<FollowingCubit, FollowingState>(
            builder: (context, state) {
          if (state is FollowingInitialState || state is FollowingInProgress) {
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.black),
                ),
              ),
            );
          } else if (state is FollowingSuccess) {
            return state.users.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    itemBuilder: (context, i) {
                      return Column(
                        children: [FollowingUserTile(state.users[i])],
                      );
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
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
