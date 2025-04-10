import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SexualPreferencesDropdown extends StatelessWidget {
  final String currentValue;
  final Function(String?) changeValue;

  final List<String> _sexualPreferences = [
    "Asexual",
    "Bisexual",
    "Homosexual",
    "Heterosexual",
    "Pansexual",
    "Otro",
    "Prefiero no responder"
  ];

  SexualPreferencesDropdown({
    Key? key,
    required this.currentValue,
    required this.changeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.5),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          prefixIcon: const Icon(Ionicons.heart_circle),
          labelText: AppLocalizations.of(context)!.orientation,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        items: _sexualPreferences.map((s) {
          return DropdownMenuItem<String>(
            child: Text(s),
            value: s,
          );
        }).toList(),
        onChanged: changeValue,
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
