import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/profile/presentation/widgets/profile/profile_info_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileInfo extends StatelessWidget {
  final TappUser user;

  const ProfileInfo(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.user,
            subtitle: user.username ?? AppLocalizations.of(context)!.user,
            icon: Icons.person,
            iconColor: AppColors.purple,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.phone,
            subtitle: user.phone ?? AppLocalizations.of(context)!.phone,
            icon: Icons.phone,
            iconColor: AppColors.blue,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.gender,
            subtitle: user.gender ?? "",
            icon: Icons.phone,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.occupation,
            subtitle: user.occupation ?? "",
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.civil_status,
            subtitle: user.maritalStatus ?? "",
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.sexual,
            subtitle: user.sexualPreference ?? "",
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.birthday,
            subtitle: DateHelper.longDate(user.birthday ?? 0),
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.hobbies,
            subtitle: user.hobby ?? "",
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
          ProfileInfoTile(
            title: AppLocalizations.of(context)!.short_desc,
            subtitle: user.description ?? "",
            icon: Icons.person,
            iconColor: AppColors.black,
          ),
        ],
      ),
    );
  }
}
