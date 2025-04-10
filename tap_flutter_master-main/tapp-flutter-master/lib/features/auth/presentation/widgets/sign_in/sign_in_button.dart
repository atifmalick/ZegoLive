import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/themes/app_colors.dart';

class SignInButton extends StatelessWidget {
  final Function()? _signInFunction;

  const SignInButton(this._signInFunction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppColors.purple,
        ),
        child: Text(
          AppLocalizations.of(context)!.login_enter,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: _signInFunction,
      ),
    );
  }
}
