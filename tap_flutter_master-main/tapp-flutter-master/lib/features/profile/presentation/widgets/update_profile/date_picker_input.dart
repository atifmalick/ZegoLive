import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePickerInput extends StatelessWidget {
  final TextEditingController ctrl;
  final DateTime? initialDate;
  final Function(DateTime)? updateDateTime;
  final bool? isRegister;
  const DatePickerInput({
    Key? key,
    required this.ctrl,
    this.initialDate,
    this.updateDateTime,
    this.isRegister,
  }) : super(key: key);

  void _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final duration = AgeCalculator.age(pickedDate);
      if (duration.years < 17) {
        // under 17 old, restricted age
        SnackbarHelper.failureSnackbar(
          AppLocalizations.of(context)!.error_occur,
          'sorry, currently only available for ages 17+',
        ).show(context);
      } else {
        updateDateTime!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.5),
      child: TextFormField(
        showCursor: true,
        readOnly: true,
        enableInteractiveSelection: false,
        onTap: () => isRegister ?? true
            ? _showDatePicker(context)
            : {FocusScope.of(context).requestFocus(FocusNode())},
        controller: ctrl,
        decoration: InputDecoration(
          prefixIcon: const Icon(Ionicons.calendar),
          labelText: AppLocalizations.of(context)!.birthday,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: const TextStyle(fontWeight: FontWeight.w600),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.the_field_not_be_blank;
          }

          return null;
        },
      ),
    );
  }
}
