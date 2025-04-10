import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmPasswordInput extends StatelessWidget {
  final TextEditingController _confirmPasswordCtrl;
  final FocusNode _confirmPasswordNode;
  final String _password;
  final bool _showPassword;

  const ConfirmPasswordInput(this._confirmPasswordCtrl,
      this._confirmPasswordNode, this._password, this._showPassword,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        cursorColor: AppColors.purple,
        autocorrect: false,
        obscureText: !_showPassword,
        controller: _confirmPasswordCtrl,
        focusNode: _confirmPasswordNode,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: AppColors.purple,
          ),
          labelText: AppLocalizations.of(context)!.signup_confirm_password,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.purple,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.purple,
              width: 0.5,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.purple,
              width: 0.5,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.signup_password_required;
          }

          if (value.isEmpty || value != _password) {
            return AppLocalizations.of(context)!.signup_password_required;
          }

          return null;
        },
      ),
    );
  }
}
