import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:tapp/features/auth/presentation/widgets/email_input.dart';
import 'package:tapp/features/auth/presentation/widgets/password_input.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_in/forgot_password_button.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_in/sign_in_button.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_in/sign_in_image.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_in/sign_in_text.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_in/sign_up_button.dart';
import 'package:tapp/features/auth/presentation/widgets/terms_and_privacy_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signInCubit = getIt<SignInCubit>();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  bool _showPassword = false;

  @override
  void dispose() {
    _signInCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIt<SharedPreferences>().setBool('onboarding', false);
    // context.read<AuthCubit>().checkSignedInUser();
    return BlocProvider<SignInCubit>(
      create: (context) => _signInCubit,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (_emailNode.hasFocus) _emailNode.unfocus();
            if (_passwordNode.hasFocus) _passwordNode.unfocus();
          },
          child: SafeArea(
            child: BlocConsumer<SignInCubit, SignInState>(
              listener: (context, state) {
                if (state is SignInFailure) {
                  SnackbarHelper.failureSnackbar(
                          AppLocalizations.of(context)!.error_occur,
                          state.message)
                      .show(context);
                }

                if (state is SignInSuccess) {
                  SnackbarHelper.successSnackbar(
                    AppLocalizations.of(context)!.welcome_again,
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is SignInInProgress || state is SignInSuccess) {
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
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SignInImage(),
                          const SignInText(),
                          EmailInput(
                            _emailCtrl,
                            _emailNode,
                          ),
                          PasswordInput(
                            _passwordCtrl,
                            _passwordNode,
                            _showPassword,
                            _togglePasswordText,
                          ),
                          const ForgotPasswordButton(),
                          SignInButton(_validateAndSignIn),
                          const SignUpButton(),
                          const TermsAndPrivacyButtons(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordText() {
    setState(() => _showPassword = !_showPassword);
  }

  void _validateAndSignIn() {
    // throw Exception(); // this is to check firebase crash analytics
    if (_formKey.currentState!.validate()) {
      _signInCubit.signInWithEmailAndPassword(
          _emailCtrl.text, _passwordCtrl.text);
    }
  }
}
