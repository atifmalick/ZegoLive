import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController _emailCtrl;
  final FocusNode _emailNode;

  EmailInput(this._emailCtrl, this._emailNode, {Key? key}) : super(key: key);
  List<String> unAllowedDomainsList = ['net', 'et'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        autocorrect: false,
        cursorColor: AppColors.purple,
        keyboardType: TextInputType.emailAddress,
        controller: _emailCtrl,
        focusNode: _emailNode,
        minLines: 1,
        maxLines: 2,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.login_email,
          prefixIcon:
              Icon(Icons.alternate_email_rounded, color: AppColors.purple),
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
            return AppLocalizations.of(context)!.enter_valid_email;
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value))
            return AppLocalizations.of(context)!.enter_valid_email;

          var splitted = value.split('.');
          var splittedLenght = splitted.length;
          String domain = splitted[splittedLenght - 1];
          if (unAllowedDomainsList.contains(domain)) {
            return "Domain not allowed";
          } else {
            return null;
          }
          // return null;
        },
      ),
    );
  }
}
