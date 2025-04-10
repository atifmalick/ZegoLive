import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/location/presentation/cubit/location_cubit.dart';
import 'package:tapp/features/notifications/presentation/cubit/firebase_notifications/firebase_notifications_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/following/unfollow_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/review/presentation/cubit/send_review_cubit.dart';
import 'package:tapp/live_stream_cubit.dart';
import 'package:tapp/styles.dart';

import 'features/feed/presentation/cubit/follow_unfollow/folllow_unfollow_cubit.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TappApp extends StatelessWidget {
  const TappApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkSignedInUser(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => getIt<ProfileCubit>(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => getIt<LocationCubit>(),
        ),
        BlocProvider<FirebaseNotificationsCubit>(
          create: (context) => getIt<FirebaseNotificationsCubit>(),
        ),
        BlocProvider<FollowUnfollowCubit>(
          create: (context) => getIt<FollowUnfollowCubit>(),
        ),
        BlocProvider<UnfollowUserCubit>(
          create: (context) => getIt<UnfollowUserCubit>(),
        ),
        BlocProvider<SendReviewCubit>(
          create: (context) => getIt<SendReviewCubit>(),
        ),
        BlocProvider<LiveStreamCubit>(
          create: (context) => getIt<LiveStreamCubit>(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          //getIt<SharedPreferences>().setBool('onboarding', false);
          if (state is OnboardingNotViewed) {
            getIt<NavigationService>()
                .navigateToAndRemoveUntil(Routes.onBoardingScreen);
          }
          if (state is Authenticated) {
            getIt<NavigationService>()
                .navigateToAndRemoveUntil(Routes.homeScreen);
          }
          if (state is MissingInfo) {
            await getIt<ProfileCubit>().getAllUserInfo();
            getIt<NavigationService>().navigateToAndRemoveUntil(
                state.redirectTo, {'updatingMissingInfo': true});
          }
          if (state is Unauthenticated) {
            getIt<NavigationService>()
                .navigateToAndRemoveUntil(Routes.signInScreen);
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localeResolutionCallback: (deviceLocale, supportLocales) {
            for (var locale in supportLocales) {
              if (locale.languageCode == deviceLocale!.languageCode) {
                getIt<AuthCubit>().deviceLocale = deviceLocale;
                return deviceLocale;
              }
            }
            return supportLocales.first;
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'MX'),
          ],
          title: 'Tapp App',
          theme: styles.appTheme,
          initialRoute: Routes.splashScreen,
          routes: Routes.routes,
          navigatorKey: getIt<NavigationService>().navigationKey,
        ),
      ),
    );
  }

  // void _hideKeyboardGlobally(BuildContext context) {
  //   FocusScopeNode currentFocus = FocusScope.of(context);
  //
  //   if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
  //     FocusManager.instance.primaryFocus.unfocus();
  //   }
  // }
}
