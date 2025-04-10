import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsHeader extends StatelessWidget {
  final TappUser user;

  const NotificationsHeader(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // We use a row because maybe in the future
          // more buttons will be added in the notifications header
          Text(
            AppLocalizations.of(context)!.notification_header,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
