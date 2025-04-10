import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/themes/app_colors.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController _phoneCtrl;
  final String _selectedCountry;
  final Function(CountryCode) _changeCountry;

  const PhoneInput(this._phoneCtrl, this._selectedCountry, this._changeCountry,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.5),
      child: TextFormField(
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: CountryCodePicker(
            initialSelection: _selectedCountry,
            favorite: const ['México', 'United States', "Perú"],
            onChanged: _changeCountry,
            showFlag: true,
          ),
          hintText: AppLocalizations.of(context)!.phone_number,
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
        validator: (value) {
          if (value == null) {
            return null;
          }
          if (value.length < 8 || value.length > 15) {
            return AppLocalizations.of(context)!.phone_must_be_9_10;
          }
          return null;
        },
      ),
    );
  }
}
