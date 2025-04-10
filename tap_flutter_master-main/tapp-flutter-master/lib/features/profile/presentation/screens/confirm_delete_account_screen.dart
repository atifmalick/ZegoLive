import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/delete_account/delete_account_cubit.dart';

class ConfirmDeleteAccountScreen extends StatelessWidget {
  final _deleteAccountCubit = getIt<DeleteAccountCubit>();
  final TextEditingController _wordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  ConfirmDeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      bloc: _deleteAccountCubit,
      listener: (context, state) {
        if (state is DeleteAccountFailure) {
          SnackbarHelper.successSnackbar(
                  AppLocalizations.of(context)!.account_deleted)
              .show(context);
          // SnackbarHelper.failureSnackbar(state.message).show(context);
          context.read<AuthCubit>().signOut();
        }
        if (state is DeleteAccountSuccess) {
          SnackbarHelper.successSnackbar(
                  AppLocalizations.of(context)!.account_deleted)
              .show(context);
          context.read<AuthCubit>().signOut();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.black),
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.delete_your_account,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: state is DeleteAccountInProgress
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.deleting_account,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.confirm_to_delete_account} "${_deleteAccountCubit.securityWord}"\n\n',
                        style: TextStyle(
                          color: AppColors.black,
                        ),
                      ),
                      SecureWordInput(
                        wordController: _wordController,
                        formKey: _key,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 160,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white),
                            icon: Icon(Icons.delete,
                                size: 20, color: AppColors.purple),
                            label: Text(
                              AppLocalizations.of(context)!.delete_your_account,
                              style: TextStyle(
                                color: AppColors.purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => {
                              if (_wordController.text ==
                                  _deleteAccountCubit.securityWord)
                                {
                                  _deleteAccountCubit.deleteAccount(),
                                }
                              else
                                {
                                  SnackbarHelper.failureSnackbar(
                                          AppLocalizations.of(context)!
                                              .error_occur,
                                          AppLocalizations.of(context)!
                                              .incorrect_word)
                                      .show(context)
                                }
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 160,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple),
                            icon: Icon(Icons.cancel,
                                size: 20, color: AppColors.white),
                            label: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class SecureWordInput extends StatelessWidget {
  final TextEditingController wordController;
  final GlobalKey<FormState> formKey;
  final _deleteAccountCubit = getIt<DeleteAccountCubit>();
  SecureWordInput(
      {Key? key, required this.wordController, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Form(
        key: formKey,
        child: TextFormField(
          autocorrect: false,
          cursorColor: AppColors.purple,
          keyboardType: TextInputType.text,
          controller: wordController,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: 'Palabra de seguridad',
            prefixIcon: Icon(Icons.security, color: AppColors.purple),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.purple,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purple,
                width: 0.5,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purple,
                width: 0.5,
              ),
            ),
          ),
          onChanged: (_) => formKey.currentState?.validate(),
          validator: (value) {
            if (value == null || value != _deleteAccountCubit.securityWord) {
              return "La palabra no coincide";
            }
            return null;
          },
        ),
      ),
    );
  }
}
