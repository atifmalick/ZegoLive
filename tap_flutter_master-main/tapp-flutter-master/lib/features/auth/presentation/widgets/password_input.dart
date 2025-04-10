import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController _passwordCtrl;
  final FocusNode _passwordNode;
  final bool _showPassword;
  final Function()? _togglePasswordText;

  const PasswordInput(this._passwordCtrl, this._passwordNode,
      this._showPassword, this._togglePasswordText,
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
        controller: _passwordCtrl,
        focusNode: _passwordNode,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.login_password,
          prefixIcon: Icon(Icons.lock_rounded, color: AppColors.purple),
          suffixIcon: IconButton(
            onPressed: _togglePasswordText,
            icon: _showPassword
                ? Icon(
                    Icons.visibility_off_rounded,
                    color: AppColors.purple,
                  )
                : Icon(Icons.visibility_rounded, color: AppColors.purple),
          ),
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
            return AppLocalizations.of(context)!.password_cannot_empty;
          }
          return null;
        },
      ),
    );
  }
}
