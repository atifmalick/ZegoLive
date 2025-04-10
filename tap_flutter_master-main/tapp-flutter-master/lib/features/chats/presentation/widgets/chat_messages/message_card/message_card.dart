import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/message_with_image.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/message_text.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (getIt<AuthCubit>().state as Authenticated).user.uid;
    Radius bottomLeft = const Radius.circular(25);
    Radius bottomRight = const Radius.circular(5);
    Color background = AppColors.purple;
    Color textColor = AppColors.white;
    Alignment alignment = Alignment.centerRight;

    if (uid != message.userId) {
      background = Colors.grey[300]!;
      textColor = AppColors.black;
      bottomLeft = const Radius.circular(5);
      bottomRight = const Radius.circular(25);
      alignment = Alignment.centerLeft;
    }

    switch (message.content.type) {
      case ContentType.image:
        return MessageWithImage(
          alignment: alignment,
          background: background,
          textColor: textColor,
          message: message,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        );
      // case ContentType.audio:
      //   return MessageWithAudio(
      //     alignment: alignment,
      //     background: background,
      //     textColor: textColor,
      //     message: message,
      //     bottomLeft: bottomLeft,
      //     bottomRight: bottomRight,
      //   );
      default:
        return MessageText(
          alignment: alignment,
          background: background,
          textColor: textColor,
          message: message,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        );
    }
  }
}
