import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';

class DialogsHelper {
  static Future<void> locationDisabledDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(AppLocalizations.of(context)!.location_disable),
          content: Text(AppLocalizations.of(context)!.current_location_service),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () => getIt<NavigationService>().pop(),
              child: Text(AppLocalizations.of(context)!.accept),
            ),
          ],
        );
      },
    );
  }

  static Future<void> locationDeniedDialog(
    BuildContext context,
    Function buttonFunction,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(AppLocalizations.of(context)!.grant_location),
          content: Text(
            AppLocalizations.of(context)!.permission_to_use,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.not_for_now),
              onPressed: () => getIt<NavigationService>().pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(AppLocalizations.of(context)!.open_settings),
              onPressed: () {
                buttonFunction();
              },
            ),
          ],
        );
      },
    );
  }
}
