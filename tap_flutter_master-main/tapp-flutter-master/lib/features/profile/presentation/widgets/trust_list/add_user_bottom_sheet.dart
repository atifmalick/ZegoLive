import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/add_user_to_trust_list/add_user_to_trust_list_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddUserBottomSheet extends StatelessWidget {
  final _usernameCtrl = TextEditingController();

  AddUserBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddUserToTrustListCubit>(
      create: (context) => getIt<AddUserToTrustListCubit>(),
      child: BlocListener<AddUserToTrustListCubit, AddUserToTrustListState>(
        listener: (context, state) {
          if (state is AddUserToTrustListSuccess) {
            getIt<NavigationService>().pop(true);
            SnackbarHelper.successSnackbar(
                    AppLocalizations.of(context)!.added_contact)
                .show(context);
          }

          if (state is AddUserToTrustListFailure) {
            getIt<NavigationService>().pop(false);
            SnackbarHelper.failureSnackbar(
                    AppLocalizations.of(context)!.error_occur, state.message)
                .show(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheet(
            enableDrag: false,
            onClosing: () => getIt<NavigationService>().pop(false),
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _usernameCtrl,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.enter_username,
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    BlocBuilder<AddUserToTrustListCubit,
                        AddUserToTrustListState>(
                      builder: (context, state) {
                        if (state is AddUserToTrustListInProgress) {
                          return SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.green),
                            ),
                          );
                        }

                        return IconButton(
                          color: AppColors.green,
                          icon: const Icon(Icons.person_add_rounded),
                          onPressed: () {
                            if (_usernameCtrl.text.isNotEmpty) {
                              final Map<String, dynamic> data = {
                                'username': _usernameCtrl.text.trim(),
                              };

                              context
                                  .read<AddUserToTrustListCubit>()
                                  .addUserToTrustList(data);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
