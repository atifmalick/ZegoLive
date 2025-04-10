import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/review/presentation/cubit/send_review_cubit.dart';
import 'package:tapp/features/review/presentation/widgets/review_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _sendReviewCubit = context.watch<SendReviewCubit>();

    return MultiBlocProvider(
        providers: [
          BlocProvider<SendReviewCubit>(
              create: (_) => getIt<SendReviewCubit>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.send_review),
          ),
          body: BlocConsumer<SendReviewCubit, SendReviewState>(
              listener: (context, state) {
            print("((((((((((((((((999;;;;");
            print(state);
            print('))))))))))))))))))))))');
            if (state is SendReviewSuccess) {
              SnackbarHelper.successSnackbar(
                AppLocalizations.of(context)!.review_submit,
              ).show(context);
            }
          }, builder: (context, state) {
            print("++++++((((((((((((((((999");
            print(state);
            print('-----------))))))))))))))))))))))');
            if (state is SendReviewInProgress) {
              return Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.black),
                  ),
                ),
              );
            }
            if (state is SendReviewSuccess) {
              SnackbarHelper.successSnackbar(
                AppLocalizations.of(context)!.review_submit,
              ).show(context);
            }
            return Column(
              children: const [
                ReviewField(),
              ],
            );
          }),
        ));
  }
}
