import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndPrivacyButtons extends StatelessWidget {
  const TermsAndPrivacyButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              child: Text(
                AppLocalizations.of(context)!.login_term,
                style: TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 12 : 10,
                ),
              ),
              onTap: () =>
                  launch('https://www.social-standard.net/terms-of-use'),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Text(
                AppLocalizations.of(context)!.login_privacy,
                style: TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 12 : 10,
                ),
              ),
              onTap: () =>
                  launch('https://www.social-standard.net/privacy-policy'),
            ),
          ),
        ],
      ),
    );
  }
}
