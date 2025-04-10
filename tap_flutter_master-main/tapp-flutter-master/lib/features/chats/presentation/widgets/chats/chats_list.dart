import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/chats/presentation/cubit/chats/chats_cubit.dart';
import 'package:tapp/features/chats/presentation/widgets/chats/chat_list_tile.dart';
import 'package:tapp/features/chats/presentation/widgets/chats/empyt_chats.dart';

class ChatsList extends StatelessWidget {
  final String uid;

  const ChatsList(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        if (state is ChatsInitial || state is ChatsLoadInProgress) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        } else if (state is ChatsLoadSuccess) {
          return state.chats.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 100),
                  itemCount: state.chats.length,
                  itemBuilder: (context, i) => ChatListTile(state.chats[i]),
                )
              : const EmptyChats();
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        }
      },
    );
  }
}
