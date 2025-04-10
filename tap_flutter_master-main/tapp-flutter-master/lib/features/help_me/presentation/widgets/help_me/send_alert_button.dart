import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/location_service.dart';
import 'package:tapp/features/help_me/presentation/cubit/send_help_me_alert/send_help_me_alert_cubit.dart';
import 'package:tapp/features/help_me/presentation/widgets/help_me/sending_alert_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/features/location/presentation/cubit/location_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendAlertButton extends StatefulWidget {
  const SendAlertButton({Key? key}) : super(key: key);

  @override
  _SendAlertButtonState createState() => _SendAlertButtonState();
}

class _SendAlertButtonState extends State<SendAlertButton> {
  final prefs = getIt<SharedPreferences>();
  final _locationService = getIt<LocationService>();
  late DateTime _onTapDownTime;
  late Timer _onTapDownTimer;
  double _onTapDownTimeElapsed = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SendingAlertProgress(_onTapDownTimeElapsed),
        BlocBuilder<SendHelpMeAlertCubit, SendHelpMeAlertState>(
          builder: (context, state) {
            if (state is SendHelpMeAlertInProgress) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.sending_alert,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTapDown: (details) {
                _onTapDownTime = DateTime.now();
                _onTapDownTimer = Timer.periodic(
                  const Duration(milliseconds: 1),
                  (timer) {
                    final timeElapsed = _onTapDownTime
                        .difference(DateTime.now())
                        .inMilliseconds
                        .abs();

                    setState(() => _onTapDownTimeElapsed = timeElapsed / 1000);

                    if (timeElapsed >= 1000) {
                      _onTapDownTimer.cancel();
                      setState(() => _onTapDownTimeElapsed = 0.0);
                      _sendAlert();
                    }
                  },
                );
              },
              onTapUp: (details) {
                _onTapDownTimer.cancel();
                setState(() => _onTapDownTimeElapsed = 0.0);
              },
              onTapCancel: () {
                _onTapDownTimer.cancel();
                setState(() => _onTapDownTimeElapsed = 0.0);
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 32,
                ),
                onPressed: () {},
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset('assets/help.png'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _sendAlert() async {
    Position position;
    final locationState = context.read<LocationCubit>().state;
    // final uid = (context.read<ProfileCubit>().state as ProfileLoadSuccess).tappUser.uid;

    if (locationState is LocationUpdated) {
      position = locationState.position;
    } else {
      position = await _locationService.getPosition();
    }

    final data = {
      'data': {
        "alertReach": prefs.getString('alertReach') ?? 'ALL',
        "alertType": 'NORMAL',
        "latitude": position.latitude,
        "longitude": position.longitude,
      }
    };

    context.read<SendHelpMeAlertCubit>().sendHelpMeAlert(data);
  }
}
