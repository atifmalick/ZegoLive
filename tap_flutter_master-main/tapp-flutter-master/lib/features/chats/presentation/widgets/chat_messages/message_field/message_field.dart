import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/add_audio_button.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/add_from_camera_button.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/add_from_gallery_button.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/message_field_content_preview.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/message_field_send_button.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/message_text_field.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/chats/presentation/cubit/send_message/send_message_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class MessageField extends StatefulWidget {
  final String chatId;
  final TappUser receiver;

  const MessageField({
    Key? key,
    required this.chatId,
    required this.receiver,
  }) : super(key: key);

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final _messageCtrl = TextEditingController(text: '');
  final FocusNode _messageNode = FocusNode();
  bool _userIsWriting = false;
  Content _content = const Content(type: ContentType.unknown);

  @override
  void initState() {
    _messageNode.addListener(() {
      _messageNodeListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 3,
            offset: Offset(0, 5),
            color: Colors.grey,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          MessageFieldContentPreview(_content, _removeContent),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: MessageTextField(_messageCtrl, _messageNode)),
              MessageFieldSendButton(_sendMessage),
            ],
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: _userIsWriting ? Colors.grey : Colors.transparent,
          ),
          _userIsWriting
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AddAudioButton(_setContent),
                      AddFromCameraButton(_setContent),
                      AddFromGalleryButton(_setContent),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _messageNodeListener() {
    setState(() => _userIsWriting = _messageNode.hasFocus);
  }

  void _setContent(
    File file, {
    ContentType contentType = ContentType.unknown,
  }) {
    setState(
      () => _content = Content(
        file: file,
        type: contentType,
        ext: path.extension(file.path),
        mimeType:
            '${contentType.toString().split('.').last}/${path.extension(file.path).split('.').last}',
      ),
    );
  }

  Future<void> _removeContent() async {
    if (await _content.file!.exists()) await _content.file?.delete();

    setState(() => _content = const Content(type: ContentType.unknown));
  }

  void _sendMessage() async {
    if (_messageCtrl.text.isNotEmpty) {
      final Map<String, dynamic> data = {
        'userId': (context.read<AuthCubit>().state as Authenticated).user.uid,
        'receiverId': widget.receiver.uid,
        'message': _messageCtrl.text,
        'chatId': widget.chatId,
      };

      data['contentBase64'] = {
        'base64Data': base64Encode(await _content.file!.readAsBytes()),
        'extention': _content.ext,
        'contentType': _content.mimeType,
      };

      context.read<SendMessageCubit>().sendMessage({'data': data});
      _removeContent();
      _messageCtrl.clear();
    }
  }
}
