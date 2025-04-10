import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/navigation/screen_arguments.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/chats/domain/entities/chat.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;

  const ChatListTile(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: CustomCircleAvatar(
        backgroundColor: AppColors.purple,
        radius: 25,
        fallbackTextSize: 18,
        url: chat.receiver.profilePicture?.url,
        fallbackText: chat.receiver.name!,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            chat.receiver.username!,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateHelper.shortDateWithTime(chat.lastMessage!.date),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessage(chat.lastMessage!),
        ],
      ),
      onTap: () {
        getIt<NavigationService>().navigateTo(
          Routes.chatMessagesScreen,
          ChatMessagesScreenArgs(
            receiver: chat.receiver,
            chatId: chat.chatId,
          ),
        );
      },
    );
  }

  Widget _buildMessage(Message message) {
    if (message.message.isEmpty) {
      switch (message.content.type) {
        case ContentType.image:
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(Ionicons.camera, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 5),
                const Text('Imagen',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          );
        case ContentType.audio:
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(Icons.volume_up, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 5),
                const Text('Audio',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          );
        default:
          return const SizedBox();
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          chat.lastMessage!.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
  }
}
