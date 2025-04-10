import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/location_service.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/help_me/presentation/cubit/send_help_me_alert/send_help_me_alert_cubit.dart';

class SendingAlertBottomSheet extends StatefulWidget {
  final String alertType;

  const SendingAlertBottomSheet({Key? key, required this.alertType})
      : super(key: key);

  @override
  _SendingAlertBottomSheetState createState() =>
      _SendingAlertBottomSheetState();
}

class _SendingAlertBottomSheetState extends State<SendingAlertBottomSheet> {
  final _sendAlertCubit = getIt<SendHelpMeAlertCubit>();
  int _millisecondsToCancel = 1;
  Timer? _cancelTimer;

  @override
  void initState() {
    _startTimerToSendAlert();
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer?.cancel();
    _sendAlertCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () => _cancelTimer?.cancel(),
      builder: (context) {
        return BlocProvider<SendHelpMeAlertCubit>(
          create: (context) => _sendAlertCubit,
          child: BlocListener<SendHelpMeAlertCubit, SendHelpMeAlertState>(
            bloc: _sendAlertCubit,
            listener: (context, state) {
              if (state is SendHelpMeAlertSuccess) {
                getIt<NavigationService>().pop();
                SnackbarHelper.successSnackbar(
                        AppLocalizations.of(context)!.alert_sent)
                    .show(context);
              }

              if (state is SendHelpMeAlertFailure) {
                getIt<NavigationService>().pop();
                SnackbarHelper.failureSnackbar(
                        AppLocalizations.of(context)!.error_occur,
                        state.message)
                    .show(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.distress_alert,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildLoadingIndicator(),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        _cancelTimer?.cancel();
                        getIt<NavigationService>().pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        Image.asset(
          'assets/sending_alert.png',
          height: 128,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 128,
          child: BlocBuilder<SendHelpMeAlertCubit, SendHelpMeAlertState>(
            bloc: _sendAlertCubit,
            builder: (context, state) {
              return state is! SendHelpMeAlertInProgress
                  ? LinearProgressIndicator(
                      value: _millisecondsToCancel / 1000,
                      valueColor: AlwaysStoppedAnimation(AppColors.purple),
                      backgroundColor: AppColors.purple.withOpacity(0.3),
                      minHeight: 6,
                    )
                  : LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.purple),
                      backgroundColor: AppColors.purple.withOpacity(0.3),
                      minHeight: 6,
                    );
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_millisecondsToCancel * 100) ~/ 1000}%',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _startTimerToSendAlert() {
    _cancelTimer?.cancel();
    _cancelTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() => _millisecondsToCancel += 1);

      if (_millisecondsToCancel >= 1000) {
        _cancelTimer?.cancel();
        _sendAlert();
      }
    });
  }

  void _sendAlert() async {
    final prefs = getIt<SharedPreferences>();
    final position = await getIt<LocationService>().getPosition();
    // final uid = (context.read<AuthCubit>().state as Authenticated).user.uid;

    final data = {
      'data': {
        "alertReach": prefs.getString('alertReach') ?? 'ALL',
        "alertType": widget.alertType,
        "latitude": position.latitude,
        "longitude": position.longitude,
      }
    };

    _sendAlertCubit.sendHelpMeAlert(data);
  }
}
