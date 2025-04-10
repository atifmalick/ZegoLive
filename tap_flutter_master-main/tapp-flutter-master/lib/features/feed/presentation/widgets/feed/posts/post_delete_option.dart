import 'package:flutter/material.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/features/feed/presentation/cubit/delete_post/delete_post_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDeleteOption extends StatelessWidget {
  final Post _post;
  final _deletePostCubit = getIt<DeletePostCubit>();

  PostDeleteOption(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;

    if (uid == _post.creator!.uid) {
      return BlocProvider<DeletePostCubit>(
        create: (context) => _deletePostCubit,
        child: BlocListener<DeletePostCubit, DeletePostState>(
          bloc: _deletePostCubit,
          listener: (context, state) {
            if (state is DeletePostInProgress) {
              SnackbarHelper.infoSnackbar(
                      AppLocalizations.of(context)!.deleting_post)
                  .show(context);
            }

            if (state is DeletePostSuccess) {
              getIt<NavigationService>().pop();
              SnackbarHelper.successSnackbar(
                      AppLocalizations.of(context)!.post_deleted)
                  .show(context);
            }

            if (state is DeletePostFailure) {
              getIt<NavigationService>().pop();
              SnackbarHelper.failureSnackbar(
                      AppLocalizations.of(context)!.error_occur, state.message)
                  .show(context);
            }
          },
          child: ListTile(
            leading: Icon(
              Icons.delete,
              color: AppColors.red,
            ),
            title: Text(
              AppLocalizations.of(context)!.delete_post,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.delete_post),
                      content: Text(
                        AppLocalizations.of(context)!.post_will_permanently,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              color: AppColors.purple,
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.cancel),
                          onPressed: () => getIt<NavigationService>().pop(),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              color: AppColors.purple,
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.eliminate),
                          onPressed: () {
                            final data = {
                              'data': {
                                'postId': _post.postId,
                              }
                            };
                            _deletePostCubit.deletePost(data);
                            getIt<NavigationService>().pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
