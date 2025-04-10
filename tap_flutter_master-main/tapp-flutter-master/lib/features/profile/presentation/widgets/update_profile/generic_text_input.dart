import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericTextInput extends StatelessWidget {
  final TextEditingController ctrl;
  final IconData icon;
  final String label;
  final String helperText;
  final Function(String?) onSave;
  final int maxLines;
  final bool enabled;

  const GenericTextInput({
    Key? key,
    required this.ctrl,
    required this.icon,
    required this.label,
    required this.onSave,
    this.helperText = '',
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: enabled,
        textCapitalization: TextCapitalization.sentences,
        controller: ctrl,
        minLines: 1,
        maxLines: maxLines,
        maxLength: 20,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon),
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          helperText: helperText.isNotEmpty ? helperText : null,
          helperStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.purple,
          ),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        onSaved: onSave,
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
