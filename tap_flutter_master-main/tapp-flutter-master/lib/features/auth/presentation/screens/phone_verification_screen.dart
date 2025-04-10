import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/auth/presentation/cubit/phone_verification/phone_verification_cubit.dart';
import 'package:tapp/features/auth/presentation/widgets/phone_verification/loading.dart';
import 'package:tapp/features/auth/presentation/widgets/phone_verification/send_code_form.dart';
import 'package:tapp/features/auth/presentation/widgets/phone_verification/send_message_form.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneVerificationCubit>(
      create: (context) => getIt<PhoneVerificationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.verify_phone_num,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              tooltip: AppLocalizations.of(context)!.sign_off,
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocConsumer<PhoneVerificationCubit, PhoneVerificationState>(
          listener: (context, state) {
            if (state is PhoneVerificationSuccess) {
              SnackbarHelper.successSnackbar(
                      AppLocalizations.of(context)!.verify_phone)
                  .show(context);
            }

            if (state is PhoneVerificationFailure) {
              SnackbarHelper.failureSnackbar(
                      AppLocalizations.of(context)!.error_occur, state.message)
                  .show(context);
              // SnackbarHelper.failureSnackbar(
              //   'No se pudo verificar el número, inténtalo más tarde.',
              // ).show(context);
            }
          },
          builder: (context, state) {
            if (state is PhoneVerificationInitial ||
                state is PhoneVerificationFailure) {
              // context.read<AuthCubit>().signOut();
              return const SendMessageForm();
            } else if (state is PhoneVerificationInProgress ||
                state is PhoneVerificationSuccess) {
              return const Loading();
            } else if (state is PhoneVerificationCodeSent) {
              return SendCodeForm(state.verificationId);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
