import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController _messageCtrl;
  final FocusNode _messageNode;

  const MessageTextField(this._messageCtrl, this._messageNode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
      child: TextField(
        controller: _messageCtrl,
        focusNode: _messageNode,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        minLines: 1,
        maxLines: 5,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: AppLocalizations.of(context)!.message,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
