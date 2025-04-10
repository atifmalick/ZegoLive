import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendMessageOption extends StatelessWidget {
  final TappUser _user;

  const SendMessageOption(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SlidableAction(
          backgroundColor: AppColors.blue,
          icon: Icons.chat_bubble_rounded,
          foregroundColor: Colors.white,
          label: AppLocalizations.of(context)!.message,
          onPressed: (_) {
            getIt<NavigationService>().navigateTo(
              Routes.checkExistingChatScreen,
              {
                'receiver': _user,
              },
            );
          },
        ),
      ),
    );
  }
}
