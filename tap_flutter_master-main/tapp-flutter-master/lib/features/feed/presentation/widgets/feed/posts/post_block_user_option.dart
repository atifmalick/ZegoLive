import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/block_user/block_user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostBlockUserOption extends StatelessWidget {
  final _cubit = getIt<BlockUserCubit>();
  final Post _post;

  PostBlockUserOption(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;

    if (uid != _post.creator!.uid) {
      return BlocProvider<BlockUserCubit>(
        create: (context) => _cubit,
        child: BlocListener<BlockUserCubit, BlockUserState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state == BlockUserState.success) {
              getIt<NavigationService>().pop();
              SnackbarHelper.successSnackbar(
                AppLocalizations.of(context)!.block_user_next_publish,
              ).show(context);
            }

            if (state == BlockUserState.failure) {
              SnackbarHelper.failureSnackbar(
                AppLocalizations.of(context)!.error_occur,
                AppLocalizations.of(context)!.user_could_not_block,
              ).show(context);
            }
          },
          child: ListTile(
            leading: Icon(
              Icons.cancel,
              color: AppColors.red,
            ),
            title: Text(
              //'Bloquear a ${_post.creator!.username}',
              '${AppLocalizations.of(context)!.block} ${_post.creator!.username}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: BlocBuilder<BlockUserCubit, BlockUserState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state == BlockUserState.inProgress) {
                  return const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            onTap: () {
              // final uid = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser.uid;
              final blockedUserId = _post.creator!.uid;

              final data = {
                'data': {
                  'blockedUserId': blockedUserId,
                },
              };

              _cubit.blockUser(data);
            },
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
