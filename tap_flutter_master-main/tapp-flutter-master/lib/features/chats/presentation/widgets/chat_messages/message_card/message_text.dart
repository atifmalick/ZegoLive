import 'package:flutter/material.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';

class MessageText extends StatelessWidget {
  final Alignment alignment;
  final Radius bottomLeft;
  final Radius bottomRight;
  final Color background;
  final Color textColor;
  final Message message;

  const MessageText({
    Key? key,
    required this.alignment,
    required this.bottomLeft,
    required this.bottomRight,
    required this.background,
    required this.textColor,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25),
            topRight: const Radius.circular(25),
            bottomLeft: bottomLeft,
            bottomRight: bottomRight,
          ),
        ),
        color: background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            message.message,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
