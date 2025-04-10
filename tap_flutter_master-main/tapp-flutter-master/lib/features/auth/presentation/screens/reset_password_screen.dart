import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/bloc/reset_password_bloc.dart';
// import 'package:tapp/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:tapp/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _resetPasswordCubit = getIt<ResetPasswordCubit>();

  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _resetPasswordCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => _resetPasswordCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.recover_password,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              SnackbarHelper.successSnackbar(
                AppLocalizations.of(context)!.send_email_recovery,
              ).show(context);
            }
            if (state is ResetPasswordFailure) {
              SnackbarHelper.failureSnackbar(
                AppLocalizations.of(context)!.error_occur,
                state.message,
              ).show(context);
            }
          },
          builder: (context, state) {
            if (state is ResetPasswordInProgress) {
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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextField(
                      cursorColor: AppColors.purple,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.mail_rounded, color: AppColors.purple),
                        hintText:
                            AppLocalizations.of(context)!.recover_enter_email,
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
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
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.recover_password),
                    onPressed: () {
                      if (_emailCtrl.text.isNotEmpty) {
                        _resetPasswordCubit
                            .resetPasswordWithEmail(_emailCtrl.text);
                        _emailCtrl.clear();
                      }
                      Future.delayed(const Duration(seconds: 3), () async {
                        getIt<NavigationService>()
                            .navigateToAndRemoveUntil(Routes.signInScreen);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
