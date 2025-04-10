import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/themes/app_colors.dart';

class SendMessageButton extends StatelessWidget {
  final Function()? _sendMessage;

  const SendMessageButton(this._sendMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
        child: Text(
          AppLocalizations.of(context)!.send_sms_code,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _sendMessage,
      ),
    );
  }
}
