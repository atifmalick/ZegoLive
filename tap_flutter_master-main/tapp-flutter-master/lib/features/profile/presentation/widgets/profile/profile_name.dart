import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileName extends StatelessWidget {
  final TappUser user;

  const ProfileName(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user.name} ${user.lastname}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 5,
              ),
              Visibility(
                visible: user.verified!,
                child: Tooltip(
                  message: AppLocalizations.of(context)!.regional_account,
                  preferBelow: false,
                  child: Icon(
                    Icons.verified,
                    size: 30,
                    color: AppColors.purple,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            user.username ?? "Username",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          user.isRegionalAlly!
              ? Tooltip(
                  message: AppLocalizations.of(context)!.regional_account,
                  preferBelow: false,
                  child: Icon(
                    Icons.verified,
                    size: 20,
                    color: AppColors.purple,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
