import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

import '../../../../../core/service_locator/init_service_locator.dart';
import '../../../../../core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhoToSendAlerts extends StatefulWidget {
  const WhoToSendAlerts({Key? key}) : super(key: key);

  @override
  _WhoToSendAlertsState createState() => _WhoToSendAlertsState();
}

class _WhoToSendAlertsState extends State<WhoToSendAlerts> {
  final prefs = getIt<SharedPreferences>();
  late String _alertReach;
  late TappUser _user;
  final List<String> females = ['Femenino', 'Female'];

  @override
  void initState() {
    _alertReach = prefs.getString('alertReach') ?? 'ALL';
    _user = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!females.contains(_user.gender)) {
      return Container();
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 0,
      ),
      title: Text(
        AppLocalizations.of(context)!.choose_help_alert,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: DropdownButton(
        style: TextStyle(
          color: AppColors.grey,
        ),
        icon: const SizedBox(),
        underline: const SizedBox(),
        value: _alertReach,
        onChanged: (choice) {
          prefs.setString('alertReach', (choice as String));
          setState(() => _alertReach = choice);
        },
        items: [
          DropdownMenuItem(
            value: 'ALL',
            child: Text(AppLocalizations.of(context)!.all),
          ),
          DropdownMenuItem(
            value: 'NEARBY_USERS',
            child: Text(AppLocalizations.of(context)!.people_around),
          ),
          DropdownMenuItem(
            value: 'TRUST_LIST',
            child: Text(AppLocalizations.of(context)!.trust_contact),
          ),
        ],
      ),
    );
  }
}
