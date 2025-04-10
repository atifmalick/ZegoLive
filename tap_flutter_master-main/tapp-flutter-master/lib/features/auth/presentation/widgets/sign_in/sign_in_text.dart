import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInText extends StatelessWidget {
  const SignInText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        AppLocalizations.of(context)!.login_title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
