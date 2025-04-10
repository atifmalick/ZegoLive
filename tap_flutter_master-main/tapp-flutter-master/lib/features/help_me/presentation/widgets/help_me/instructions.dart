import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/features/help_me/presentation/cubit/send_help_me_alert/send_help_me_alert_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendHelpMeAlertCubit, SendHelpMeAlertState>(
      builder: (context, state) {
        if (state is! SendHelpMeAlertInProgress) {
          return Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
            child: Text(
              AppLocalizations.of(context)!.press_hold,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
