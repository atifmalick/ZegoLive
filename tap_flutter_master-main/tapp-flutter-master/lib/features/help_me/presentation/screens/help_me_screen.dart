import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapp/core/helpers/dialogs_helper.dart';
import 'package:tapp/core/helpers/permissions_helper.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/help_me/presentation/widgets/help_me/alert_type_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpMeScreen extends StatefulWidget {
  const HelpMeScreen({Key? key}) : super(key: key);

  @override
  _HelpMeScreenState createState() => _HelpMeScreenState();
}

class _HelpMeScreenState extends State<HelpMeScreen> {
  @override
  void initState() {
    _askForLocationPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
        title: Text(
          AppLocalizations.of(context)!.ask_for_help,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.press_button,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const Spacer(),
            Align(
              child: AlertTypeButton(
                asset: 'assets/sad.png',
                text: AppLocalizations.of(context)!.i_need_support,
                alertType: 'NORMAL',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.please_only_tool,
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _askForLocationPermissions() async {
    await PermissionsHelper.requestLocationPermission(
      ifLocationDisabled: () => DialogsHelper.locationDisabledDialog(context),
    );
  }
}
