import 'package:flutter/material.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/image_preview.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class MessageFieldContentPreview extends StatelessWidget {
  final Content _content;
  final Function()? _removeContent;

  const MessageFieldContentPreview(this._content, this._removeContent,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_content.type) {
      case ContentType.image:
        return ImagePreview(_content, _removeContent);
      // case ContentType.audio:
      //   return AudioPreview(_content.file, _removeContent);
      //   break;
      default:
        return const SizedBox();
    }
  }
}
