import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/share_post/share_post_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharePostOption extends StatelessWidget {
  final _cubit = getIt<SharePostCubit>();
  final Post _post;

  SharePostOption(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SharePostCubit>(
      create: (context) => _cubit,
      child: BlocListener<SharePostCubit, SharePostState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state == SharePostState.success) {
            getIt<NavigationService>().pop();
            SnackbarHelper.successSnackbar(
                    AppLocalizations.of(context)!.share_post)
                .show(context);
          }

          if (state == SharePostState.failure) {
            SnackbarHelper.failureSnackbar(
              AppLocalizations.of(context)!.error_occur,
              AppLocalizations.of(context)!.could_not_be_shared,
            ).show(context);
          }
        },
        child: ListTile(
          leading: Icon(
            Icons.share,
            color: AppColors.green,
          ),
          title: Text(
            AppLocalizations.of(context)!.share,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            _cubit.sharePost(_post);
          },
        ),
      ),
    );
  }
}
