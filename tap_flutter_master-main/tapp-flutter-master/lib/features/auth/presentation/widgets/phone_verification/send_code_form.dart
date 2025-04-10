import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/phone_verification/phone_verification_cubit.dart';

class SendCodeForm extends StatefulWidget {
  final String verificationId;

  const SendCodeForm(this.verificationId, {Key? key}) : super(key: key);

  @override
  _SendCodeFormState createState() => _SendCodeFormState();
}

class _SendCodeFormState extends State<SendCodeForm> {
  String get verificationId => widget.verificationId;

  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.5),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _codeCtrl,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.keyboard),
                hintText: AppLocalizations.of(context)!.write_6_code,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.field_required;
                }
                if (value.length != 6) {
                  return AppLocalizations.of(context)!.write_6_code;
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
              ),
              child: Text(
                AppLocalizations.of(context)!.verify_code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _validateAndSendCode,
            ),
          )
        ],
      ),
    );
  }

  void _validateAndSendCode() {
    if (_formKey.currentState!.validate()) {
      context.read<PhoneVerificationCubit>().validateSmsCode(
            verificationId,
            _codeCtrl.text,
          );
    }
  }
}
