import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

class FeedFeature extends StatelessWidget {
  final Function(int) _previousPage;

  const FeedFeature(this._previousPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Image.asset('assets/news_feed.png'),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  //'Entérate de lo que pasa a tu alrededor',
                  AppLocalizations.of(context)!.feed_feature_title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Text(
                    // 'A medida que cambies de ubicación, tu feed se actualizará con las publicaciones de las personas cercanas.'
                    // '\n\nTambién puedes publicar fotos, imágenes, audio y texto.',
                    AppLocalizations.of(context)!.feed_feature_msg,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    elevation: 0,
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    //'Atrás',
                    AppLocalizations.of(context)!.btn_back,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => _previousPage(2),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    //'Empezar',
                    AppLocalizations.of(context)!.btn_begin,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    getIt<SharedPreferences>().setBool('onboarding', true);
                    context.read<AuthCubit>().checkSignedInUser();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
