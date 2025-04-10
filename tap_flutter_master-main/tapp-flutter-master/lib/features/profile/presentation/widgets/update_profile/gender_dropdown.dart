import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

class GenderDropdown extends StatelessWidget {
  final String currentValue;
  final Function(String?) changeValue;

  final bool enable;

  GenderDropdown({
    Key? key,
    required this.currentValue,
    required this.changeValue,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _genders = [
      AppLocalizations.of(context)!.male,
      AppLocalizations.of(context)!.female,
      AppLocalizations.of(context)!.nonbinary,
      AppLocalizations.of(context)!.intersex,
      AppLocalizations.of(context)!.other,
      AppLocalizations.of(context)!.prefer_not_to_answer
    ];
    var locale = getIt<AuthCubit>().deviceLocale;

    return Container(
      padding: const EdgeInsets.all(15.5),
      child: DropdownButtonFormField<String>(
        value: locale?.languageCode == 'en'
            ? genderMapVal[currentValue]
            : currentValue,
        decoration: InputDecoration(
          prefixIcon: const Icon(Ionicons.male_female),
          labelText: AppLocalizations.of(context)!.gender,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        items: _genders.map((s) {
          return DropdownMenuItem<String>(
            child: Text(s),
            value: s,
          );
        }).toList(),
        onChanged: enable ? changeValue : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.the_field_not_be_blank;
          }
          return null;
        },
      ),
    );
  }

  Map<String, String> genderMapVal = {
    "Masculino": "Male",
    "Femenino": "Female",
    "No binario": "Nonbinary",
    "Intersexo": "Intersex",
    "Otro": "Other",
    "Prefiero no responder": "Prefer not to answer",
    // "Male": "Masculino",
    // "Female": "Femenino",
    // "Nonbinary": "No binario",
    // "Intersex": "Intersexo",
    // "Other": "Otro",
    // "Prefer not to answer": "Prefiero no responder"
  };
}
