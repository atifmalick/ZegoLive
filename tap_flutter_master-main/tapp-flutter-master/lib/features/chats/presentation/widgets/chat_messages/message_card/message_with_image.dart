import 'package:flutter/material.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/image_preview.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/message_text.dart';

class MessageWithImage extends StatelessWidget {
  final Alignment alignment;
  final Radius bottomLeft;
  final Radius bottomRight;
  final Color background;
  final Color textColor;
  final Message message;

  const MessageWithImage({
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
    return Column(
      children: [
        Align(
          alignment: alignment,
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
              ),
            ),
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ImagePreview(
                url: message.content.url!,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
              ),
            ),
          ),
        ),
        message.message.isNotEmpty
            ? MessageText(
                alignment: alignment,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
                background: background,
                textColor: textColor,
                message: message,
              )
            : const SizedBox(),
      ],
    );
  }
}
