import 'package:flutter/material.dart';

import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/snackbar_helper.dart';
import '../../../../../core/service_locator/init_service_locator.dart';
import '../../cubit/update_profile/update_profile_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HideProfilePicture extends StatelessWidget {
  final _updateProfileCubit = getIt<UpdateProfileCubit>();

  HideProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    return BlocProvider<UpdateProfileCubit>(
      create: (context) => _updateProfileCubit,
      child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        bloc: _updateProfileCubit,
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            getIt<ProfileCubit>().replaceUserInfo(state.user);
          }

          if (state is UpdateProfileFailure) {
            SnackbarHelper.failureSnackbar(
              AppLocalizations.of(context)!.error_occur,
              AppLocalizations.of(context)!.error_occured_preform,
            ).show(context);
          }
        },
        child: SwitchListTile(
          isThreeLine: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          title: Text(
            AppLocalizations.of(context)!.hide_my_picture,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.your_photo_not_appear_in_post,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          value: !(user.isProfilePictureEnabled ?? true),
          onChanged: (value) {
            final userData = {
              'uid': user.uid,
              'isProfilePictureEnabled': !value,
            };

            _updateProfileCubit.updateProfileInfo({'userData': userData});

            SnackbarHelper.infoSnackbar(AppLocalizations.of(context)!.hang_on)
                .show(context);
          },
        ),
      ),
    );
  }
}
