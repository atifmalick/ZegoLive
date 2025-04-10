import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpButton extends StatelessWidget {
  final Function()? _signUpFunction;

  const SignUpButton(this._signUpFunction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.signup_title1,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: _signUpFunction,
      ),
    );
  }
}
