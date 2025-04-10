import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/chats/presentation/cubit/chats/chats_cubit.dart';
import 'package:tapp/features/chats/presentation/widgets/chats/chats_header.dart';
import 'package:tapp/features/chats/presentation/widgets/chats/chats_list.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _chatsCubit = getIt<ChatsCubit>();

  @override
  void dispose() {
    _chatsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadSuccess) {
          return BlocProvider<ChatsCubit>(
            create: (context) => _chatsCubit..getChats(state.tappUser.uid!),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  await _chatsCubit.getChats(state.tappUser.uid!);
                },
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    ChatsHeader(state.tappUser),
                    ChatsList(state.tappUser.uid!),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
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
