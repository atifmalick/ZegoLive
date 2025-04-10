import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';
import 'package:tapp/features/notifications/presentation/cubit/report_user_notification/report_user_notification_cubit.dart';

class ReportNotificationOption extends StatelessWidget {
  final _cubit = getIt<ReportUserNotificationCubit>();
  final TappNotification _notification;

  ReportNotificationOption(this._notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SlidableAction(
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          icon: Icons.error,
          label: AppLocalizations.of(context)!.report,
          onPressed: (_) {
            _showReportDialog(context);
          },
        ),
      ),
    );
  }

  Future<bool?> _showReportDialog(BuildContext context) {
    final _reasonCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.tell_us_reason),
          content: BlocListener<ReportUserNotificationCubit,
              ReportUserNotificationState>(
            bloc: _cubit,
            listener: (context, state) {
              if (state == ReportUserNotificationState.success) {
                getIt<NavigationService>().pop(true);
                SnackbarHelper.successSnackbar(
                  AppLocalizations.of(context)!.thank_you_for_report,
                ).show(context);
              }

              if (state == ReportUserNotificationState.failure) {
                SnackbarHelper.failureSnackbar(
                  AppLocalizations.of(context)!.error_occur,
                  AppLocalizations.of(context)!.notify_could_not_report,
                ).show(context);
              }
            },
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _reasonCtrl,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.reason,
                  hintText: AppLocalizations.of(context)!.false_alarm,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .do_not_leave_empty_reason;
                  }

                  return null;
                },
              ),
            ),
          ),
          actions: [
            BlocBuilder<ReportUserNotificationCubit,
                ReportUserNotificationState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state == ReportUserNotificationState.inProgress) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Wrap(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          getIt<NavigationService>().pop(null);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.white),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(AppLocalizations.of(context)!.report),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final data = {
                              'data': {
                                'docId': _notification.id,
                                'reason': _reasonCtrl.text,
                              },
                            };

                            _cubit.reportUserNotification(data);
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
