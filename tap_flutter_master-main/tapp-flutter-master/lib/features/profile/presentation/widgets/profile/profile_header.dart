import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const IconButton(
            icon: SizedBox(),
            onPressed: null,
          ),
          Text(
            AppLocalizations.of(context)!.profile,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 26),
            onPressed: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.sign_off,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      AppLocalizations.of(context)!.you_want_to_logout,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                        ),
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () => getIt<NavigationService>().pop(false),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          textStyle: TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.accept),
                        onPressed: () => getIt<NavigationService>().pop(true),
                      ),
                    ],
                  );
                },
              );

              if (result) {
                getIt<NavigationService>()
                    .navigateToAndRemoveUntil(Routes.splashScreen);
                await context.read<AuthCubit>().signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}
