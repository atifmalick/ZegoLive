import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';

class MessageFieldSendButton extends StatelessWidget {
  final Function()? _sendMessage;

  const MessageFieldSendButton(this._sendMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          splashRadius: 20,
          color: AppColors.purple,
          icon: const Icon(Icons.near_me_rounded),
          onPressed: _sendMessage,
        ),
      ),
    );
  }
}
