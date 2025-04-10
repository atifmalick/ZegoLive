import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsForHelpMeScreen extends StatelessWidget {
  const ContactsForHelpMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context)!.trust_contact)),
        body: Text(AppLocalizations.of(context)!.hello));
  }
}
