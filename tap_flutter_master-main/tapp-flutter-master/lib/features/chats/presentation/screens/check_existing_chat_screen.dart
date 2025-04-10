import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/navigation/screen_arguments.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/chats/presentation/cubit/chats/chats_cubit.dart';

class CheckExistingChatScreen extends StatelessWidget {
  const CheckExistingChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;
    final receiver =
        (ModalRoute.of(context)!.settings.arguments as Map)['receiver'];

    return BlocProvider<ChatsCubit>(
      create: (context) => getIt<ChatsCubit>()..getChats(uid),
      child: BlocListener<ChatsCubit, ChatsState>(
        listener: (context, state) async {
          if (state is ChatsLoadSuccess && receiver != null) {
            final chat = state.chats.singleWhereOrNull(
              (chat) =>
                  chat.receiver.uid == receiver.uid ||
                  chat.receiver.username == receiver.username,
            );
            getIt<NavigationService>().navigateToAndReplace(
              Routes.chatMessagesScreen,
              ChatMessagesScreenArgs(
                receiver: chat != null ? chat.receiver : receiver,
                chatId: chat != null ? chat.chatId : '',
                newChat: chat == null,
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
