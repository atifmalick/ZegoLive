import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:tapp/features/auth/presentation/cubit/phone_verification/phone_verification_cubit.dart';
import 'package:tapp/features/auth/presentation/widgets/phone_verification/phone_input.dart';
import 'package:tapp/features/auth/presentation/widgets/phone_verification/send_message_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageForm extends StatefulWidget {
  const SendMessageForm({Key? key}) : super(key: key);

  @override
  _SendMessageFormState createState() => _SendMessageFormState();
}

class _SendMessageFormState extends State<SendMessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  String _selectedCountry = 'México';
  String _phonePrefix = '+52';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          PhoneInput(
            _phoneCtrl,
            _selectedCountry,
            _changeCountry,
          ),
          SendMessageButton(
            _validateAndSendMessage,
          ),
        ],
      ),
    );
  }

  void _changeCountry(CountryCode countryCode) {
    return setState(() {
      _selectedCountry = countryCode.name!;
      _phonePrefix = countryCode.dialCode!;
    });
  }

  void _validateAndSendMessage() {
    if (_formKey.currentState!.validate()) {
      context.read<PhoneVerificationCubit>().startPhoneVerification(
            '$_phonePrefix${_phoneCtrl.text.trim()}',
          );
    }
  }
}
