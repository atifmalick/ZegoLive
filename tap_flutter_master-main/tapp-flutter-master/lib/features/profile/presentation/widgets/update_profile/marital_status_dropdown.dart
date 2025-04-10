import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MaritalStatusDropdown extends StatelessWidget {
  final String currentValue;
  final Function(String?) changeValue;

  final List<String> _maritalStatuses = [
    "Solter@",
    "En una relación",
    "Casad@",
    "Viud@",
    "Separad@",
    "Divorciad@",
    "Otro",
    "Prefiero no responder"
  ];

  MaritalStatusDropdown({
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
          prefixIcon: const Icon(Ionicons.heart),
          labelText: AppLocalizations.of(context)!.civil_status,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        items: _maritalStatuses.map((m) {
          return DropdownMenuItem<String>(
            child: Text(m),
            value: m,
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
