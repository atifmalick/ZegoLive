import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_up/sign_up_image.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_up/sign_up_text.dart';
import 'package:tapp/features/auth/presentation/widgets/terms_and_privacy_buttons.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_up/confirm_password_input.dart';
import 'package:tapp/features/auth/presentation/widgets/email_input.dart';
import 'package:tapp/features/auth/presentation/widgets/password_input.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_up/sign_in_button.dart';
import 'package:tapp/features/auth/presentation/widgets/sign_up/sign_up_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpCubit = getIt<SignUpCubit>();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _confirmPasswordNode = FocusNode();
  String _password = '';
  bool _showPassword = false;

  @override
  void initState() {
    // Listen to the latest value of the password field
    // And update the _password variable to match validation
    // with the confirm password field
    _passwordCtrl.addListener(() {
      setState(() => _password = _passwordCtrl.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    _signUpCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => _signUpCubit,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (_emailNode.hasFocus) _emailNode.unfocus();
            if (_passwordNode.hasFocus) _passwordNode.unfocus();
            if (_confirmPasswordNode.hasFocus) _passwordNode.unfocus();
          },
          onPanUpdate: (details) {
            if (_emailNode.hasFocus) _emailNode.unfocus();
            if (_passwordNode.hasFocus) _passwordNode.unfocus();
            if (_confirmPasswordNode.hasFocus) _passwordNode.unfocus();
          },
          child: SafeArea(
            child: BlocConsumer<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is SignUpFailure) {
                  SnackbarHelper.failureSnackbar(
                          AppLocalizations.of(context)!.error_occur,
                          state.message)
                      .show(context);
                }

                if (state is SignUpSuccess) {
                  SnackbarHelper.successSnackbar(
                    AppLocalizations.of(context)!.register_success,
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is SignUpInProgress || state is SignUpSuccess) {
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SignUpImage(),
                          const SignUpText(),
                          EmailInput(_emailCtrl, _emailNode),
                          PasswordInput(
                            _passwordCtrl,
                            _passwordNode,
                            _showPassword,
                            _togglePasswordText,
                          ),
                          ConfirmPasswordInput(
                            _confirmPasswordCtrl,
                            _confirmPasswordNode,
                            _password,
                            _showPassword,
                          ),
                          SignUpButton(_validateAndSignUp),
                          const SignInButton(),
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

  void _validateAndSignUp() {
    if (_formKey.currentState!.validate()) {
      _signUpCubit.signUpWithEmailAndPassword(
        _emailCtrl.text,
        _passwordCtrl.text,
      );
    }
  }
}
