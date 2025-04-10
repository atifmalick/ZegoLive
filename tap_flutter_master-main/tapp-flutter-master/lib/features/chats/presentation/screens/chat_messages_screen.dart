import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/navigation/screen_arguments.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/chats/presentation/cubit/messages/messages_cubit.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_field/message_field.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/messages_list.dart';
import 'package:tapp/features/chats/presentation/cubit/send_message/send_message_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessagesScreen extends StatelessWidget {
  final ChatMessagesScreenArgs? args;

  const ChatMessagesScreen({Key? key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MessagesCubit>(
          create: (context) {
            if (!args!.newChat) {
              return getIt<MessagesCubit>()..getChatMessages(args!.chatId);
            }

            return getIt<MessagesCubit>();
          },
        ),
        BlocProvider<SendMessageCubit>(
          create: (context) => getIt<SendMessageCubit>(),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCircleAvatar(
                backgroundColor: AppColors.purple,
                radius: 16,
                fallbackTextSize: 12,
                url: args!.receiver!.profilePicture?.url,
                fallbackText: args!.receiver!.name!,
              ),
              const SizedBox(width: 10),
              Text(
                args!.receiver!.username!,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocListener<SendMessageCubit, SendMessageState>(
          listener: (context, state) {
            if (state is SendMessageSuccess) {
              context.read<MessagesCubit>().addMessage(state.message);
            }

            if (state is SendMessageFailure) {
              SnackbarHelper.failureSnackbar(
                      AppLocalizations.of(context)!.error_occur,
                      AppLocalizations.of(context)!.message_could_not_send)
                  .show(context);
            }
          },
          child: Column(
            children: [
              const Expanded(child: MessagesList()),
              MessageField(
                chatId: args!.chatId,
                receiver: args!.receiver!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
