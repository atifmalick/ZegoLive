import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/report_post/report_post_cubit.dart';

class PostReportOption extends StatelessWidget {
  final _cubit = getIt<ReportPostCubit>();
  final Post _post;

  PostReportOption(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<AuthCubit>().state as Authenticated).user.uid;

    if (uid != _post.creator!.uid) {
      return BlocProvider<ReportPostCubit>(
        create: (context) => _cubit,
        child: ListTile(
          enabled: true,
          leading: Icon(
            Icons.error,
            color: AppColors.orange,
          ),
          title: Text(
            '${AppLocalizations.of(context)!.report_publication} ${_post.creator!.username}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            final reported = await _showReportDialog(context);

            if (reported != null) {
              getIt<NavigationService>().pop();
              SnackbarHelper.successSnackbar(
                AppLocalizations.of(context)!.thank_you_for_report,
              ).show(context);
            }
          },
        ),
      );
    }

    return const SizedBox();
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
          content: BlocListener<ReportPostCubit, ReportPostState>(
            bloc: _cubit,
            listener: (context, state) {
              if (state == ReportPostState.success) {
                getIt<NavigationService>().pop(true);
              }

              if (state == ReportPostState.failure) {
                SnackbarHelper.failureSnackbar(
                  AppLocalizations.of(context)!.error_occur,
                  AppLocalizations.of(context)!.post_could_not_report,
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
                  hintText:
                      AppLocalizations.of(context)!.inappropriate_languare,
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
            BlocBuilder<ReportPostCubit, ReportPostState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state == ReportPostState.inProgress) {
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
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          getIt<NavigationService>().pop(null);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.report),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final data = {
                              'data': {
                                'docId': _post.postId,
                                'reason': _reasonCtrl.text,
                              },
                            };

                            _cubit.reportPost(data);
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
