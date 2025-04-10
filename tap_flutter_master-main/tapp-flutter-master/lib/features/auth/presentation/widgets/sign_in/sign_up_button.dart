import 'package:flutter/material.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        child: Text(
          AppLocalizations.of(context)!.login_signup,
          style: TextStyle(
            color: AppColors.black,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: () => getIt<NavigationService>().navigateTo(Routes.signUpScreen),
      ),
    );
  }
}
