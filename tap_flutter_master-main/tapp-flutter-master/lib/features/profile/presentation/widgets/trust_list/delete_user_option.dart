import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/remove_user_from_trust_list/remove_user_from_trust_list_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/trustList/trust_list_cubit.dart';

class DeleteUserOption extends StatelessWidget {
  final TappUser _user;
  final _removeUserCubit = getIt<RemoveUserFromTrustListCubit>();

  DeleteUserOption(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;

    return BlocProvider<RemoveUserFromTrustListCubit>(
      create: (context) => _removeUserCubit,
      child: BlocListener<RemoveUserFromTrustListCubit,
          RemoveUserFromTrustListState>(
        listener: (context, state) {
          if (state is RemoveUserFromTrustListInProgress) {
            SnackbarHelper.infoSnackbar(
                    AppLocalizations.of(context)!.delete_contact)
                .show(context);
          }

          if (state is RemoveUserFromTrustListSuccess) {
            SnackbarHelper.successSnackbar(
                    AppLocalizations.of(context)!.contact_deleted)
                .show(context);
            context.read<TrustListCubit>().getTrustList(uid);
          }

          if (state is RemoveUserFromTrustListFailure) {
            SnackbarHelper.failureSnackbar(
                    AppLocalizations.of(context)!.error_occur, state.message)
                .show(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SlidableAction(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              label: 'Eliminar',
              icon: Icons.delete_rounded,
              onPressed: (_) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.delete_contact),
                      content: Text(
                        '${_user.name} ${AppLocalizations.of(context)!.will_remove_from_your_trust}',
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
                            backgroundColor: AppColors.purple,
                          ),
                          child: Text(AppLocalizations.of(context)!.eliminate),
                          onPressed: () {
                            final data = {
                              'removeUserId': _user.uid,
                            };

                            _removeUserCubit.removeUserFromTrustList(data);
                            getIt<NavigationService>().pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
