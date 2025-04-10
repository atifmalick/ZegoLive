import 'package:flutter/material.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: InkWell(
        child: Text(
          AppLocalizations.of(context)!.forgot_password,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () {
          getIt<NavigationService>().navigateTo(Routes.forgotPasswordScreen);
        },
      ),
    );
  }
}
