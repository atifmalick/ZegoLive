import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/profile/profile_avatar.dart';
import 'package:tapp/features/profile/presentation/widgets/profile/profile_header.dart';
import 'package:tapp/features/profile/presentation/widgets/profile/profile_name.dart';
import 'package:tapp/features/profile/presentation/widgets/settings/basic_settings.dart';

class ProfileAndSettingsScreen extends StatelessWidget {
  const ProfileAndSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadSuccess) {
          return SafeArea(
            bottom: false,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 200),
              physics: const BouncingScrollPhysics(),
              children: [
                const ProfileHeader(),
                ProfileAvatar(state.tappUser),
                ProfileName(state.tappUser),
                const Divider(indent: 10, endIndent: 10),
                BasicSettings(verified: state.tappUser.verified!),
              ],
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
