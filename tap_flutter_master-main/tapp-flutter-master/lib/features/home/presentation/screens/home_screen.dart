import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapp/core/Static/cordinates.dart';
import 'package:tapp/core/helpers/dialogs_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/presentation/screens/feed.dart';
import 'package:tapp/features/home/presentation/widgets/home/bottom_item.dart';
import 'package:tapp/features/location/presentation/cubit/location_cubit.dart';
import 'package:tapp/features/notifications/presentation/cubit/firebase_notifications/firebase_notifications_cubit.dart';
import 'package:tapp/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/screens/go_live_screen.dart';
import 'package:tapp/features/profile/presentation/screens/profile_and_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController? pageController;
  User? user;
  TappUser? tapUser;
  String? gender = '';
  final List<String> females = ['Femenino', 'Female'];

  Future<void> _getLocationStatus() async {
    final permissionStatus = await Permission.location.status;
    final serviceStatus = await Permission.location.serviceStatus;

    debugPrint(permissionStatus.toString());
    switch (permissionStatus) {
      case PermissionStatus.granted:
        if (serviceStatus.isDisabled) {
          await DialogsHelper.locationDisabledDialog(context);
        }
        _getLocationAlwaysStatus();

        break;
      case PermissionStatus.denied:
        await Permission.location.request();
        await _getLocationStatus();

        break;
      case PermissionStatus.permanentlyDenied:
        await DialogsHelper.locationDeniedDialog(
          context,
          () async {
            await openAppSettings();
            getIt<NavigationService>().pop();
          },
        );

        break;
      case PermissionStatus.restricted:
        await Permission.location.request();
        await _getLocationStatus();

        break;
      default:
        break;
    }
  }

  Future<void> _getLocationAlwaysStatus() async {
    final permissionStatus = await Permission.locationAlways.status;

    debugPrint(permissionStatus.toString());
    switch (permissionStatus) {
      case PermissionStatus.granted:
        getLocation();
        break;
      case PermissionStatus.denied:
        await Permission.locationAlways.request();
        await _getLocationAlwaysStatus();
        break;
      case PermissionStatus.permanentlyDenied:
        await DialogsHelper.locationDeniedDialog(
          context,
          () async {
            await openAppSettings();
            getIt<NavigationService>().pop();
          },
        );
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    _getLocationStatus();
    pageController = PageController(initialPage: 0, keepPage: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        user = (context.read<AuthCubit>().state as Authenticated).user;
        await context.read<ProfileCubit>().updateToken();
        await context.read<ProfileCubit>().getAllUserInfo();

        await context.read<LocationCubit>().startLocation(user!.uid);

        await context.read<FirebaseNotificationsCubit>().configureFln();
        await context.read<FirebaseNotificationsCubit>().configureFcm();
        await context
            .read<FirebaseNotificationsCubit>()
            .getNotificationsFromTerminatedState();
        getLocation();
      });
    });

    super.initState();
  }

  Future<void> getLocation() async {
    await AppCordinates.getCurrentLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            // Update user location every time current location changes
            if (state is LocationUpdated) {
              context.read<ProfileCubit>().updateUserLocation(
                    state.position.latitude,
                    state.position.longitude,
                    user!.uid,
                  );
            }
          },
        ),
        BlocListener<FirebaseNotificationsCubit, FirebaseNotificationsState>(
          listener: (context, state) {
            // For new chat message notifications
            if (state is FirebaseChatNotificationReceived) {
              getIt<NavigationService>().navigateTo(
                Routes.checkExistingChatScreen,
                {'receiver': TappUser(username: state.notification.title)},
              );
            }

            // When someone near sends an alert message, display the map dialog
            // no matter if the app is in foreground, background or terminated
            if (state is FirebaseHelpMeNotificationReceived) {
              getIt<NavigationService>().navigateTo(
                Routes.alertMapScreen,
                {
                  'alertPosition': Position(
                    latitude: state.notification.latitude!,
                    longitude: state.notification.longitude!,
                    timestamp: DateTime.now(),
                    accuracy: 0,
                    altitude: 0,
                    speed: 0,
                    heading: 0,
                    speedAccuracy: 0,
                    altitudeAccuracy: 0,
                    headingAccuracy: 0,
                  ),
                  'alertType': state.notification.alertType,
                },
              );
            }
          },
        ),
      ],
      child: Scaffold(
        extendBody: true,
        body: Container(
          color: Colors.transparent,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [
              FeedScreen(),
              NotificationsScreen(),
              // TrustListScreen(),

              GoLivePage(),
              ProfileAndSettingsScreen(),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) => current is ProfileLoadSuccess,
            builder: (context, state) {
              if (state is ProfileLoadSuccess) {
                gender = state.tappUser.gender;
              }
              return Visibility(
                visible: females.contains(gender),
                child: FloatingActionButton(
                  backgroundColor: AppColors.purple,
                  heroTag: null,
                  splashColor: Colors.white,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/help_icon.png'),
                    ),
                  ),
                  onPressed: () {
                    getIt<NavigationService>().navigateTo(Routes.helpMeScreen);
                  },
                ),
              );
            }),
        floatingActionButtonLocation: females.contains(gender)
            ? FloatingActionButtonLocation.centerDocked
            : FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 30,
          color: AppColors.white,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                BottomItem(
                  color: AppColors.purple,
                  icon: Ionicons.home,
                  active: _currentIndex == 0,
                  onTap: () => animateToPage(0),
                ),
                BottomItem(
                  color: AppColors.purple,
                  icon: Ionicons.notifications,
                  active: _currentIndex == 1,
                  onTap: () => animateToPage(1),
                ),
                const SizedBox(width: 30),
                // BottomItem(
                //   color: AppColors.purple,
                //   icon: Ionicons.person_add,
                //   active: _currentIndex == 2,
                //   onTap: () => animateToPage(2),
                // ),
                BottomItem(
                  color: AppColors.purple,
                  icon: Ionicons.videocam,
                  active: _currentIndex == 2,
                  onTap: () => animateToPage(2),
                ),
                BottomItem(
                  color: AppColors.purple,
                  icon: Ionicons.person,
                  active: _currentIndex == 3,
                  onTap: () => animateToPage(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void animateToPage(int indexPage) async {
    setState(() {
      pageController!.animateToPage(
        indexPage,
        duration: const Duration(milliseconds: 10),
        curve: Curves.decelerate,
      );
      _currentIndex = indexPage;
    });
  }
}
