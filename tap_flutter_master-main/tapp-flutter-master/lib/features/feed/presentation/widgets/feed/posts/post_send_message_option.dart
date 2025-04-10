import 'package:flutter/material.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostSendMessageOption extends StatelessWidget {
  final Post _post;

  const PostSendMessageOption(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;

    if (uid != _post.creator!.uid) {
      return ListTile(
        leading: Icon(
          Icons.chat_bubble_rounded,
          color: AppColors.blue,
        ),
        title: Text(
          '${AppLocalizations.of(context)!.send_message_to} ${_post.creator!.username}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          getIt<NavigationService>()
              .navigateTo(Routes.checkExistingChatScreen, {
            'receiver': _post.creator,
          });
        },
      );
    }

    return const SizedBox();
  }
}
