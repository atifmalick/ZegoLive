import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/help_me/presentation/cubit/send_help_me_alert/send_help_me_alert_cubit.dart';

class SendingAlertProgress extends StatelessWidget {
  final double _onTapDownTimeElapsed;

  const SendingAlertProgress(this._onTapDownTimeElapsed, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.height * 0.35,
      child: BlocBuilder<SendHelpMeAlertCubit, SendHelpMeAlertState>(
        builder: (context, state) {
          if (state is SendHelpMeAlertInProgress) {
            return CircularProgressIndicator(
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation(AppColors.purple),
            );
          }
          return CircularProgressIndicator(
            strokeWidth: 8,
            valueColor: AlwaysStoppedAnimation(AppColors.purple),
            value: _onTapDownTimeElapsed,
          );
        },
      ),
    );
  }
}
