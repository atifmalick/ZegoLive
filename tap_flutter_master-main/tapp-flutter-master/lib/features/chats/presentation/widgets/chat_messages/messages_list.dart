import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/message_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/features/chats/presentation/cubit/messages/messages_cubit.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          if (state is MessagesLoadInProgress) {
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.black),
                ),
              ),
            );
          } else if (state is MessagesLoadSuccess) {
            return ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              itemCount: state.messages.length,
              itemBuilder: (context, i) {
                return MessageCard(state.messages[i]);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
