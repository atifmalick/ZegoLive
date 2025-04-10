import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tapp/core/helpers/dialogs_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/onboarding/presentation/widgets/feed_feature.dart';
import 'package:tapp/features/onboarding/presentation/widgets/insecurity_request.dart';
import 'package:tapp/features/onboarding/presentation/widgets/onboarding_first.dart';
import 'package:tapp/features/onboarding/presentation/widgets/onboarding_third.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  final _pageController = PageController(initialPage: 0);
  var pages;
  PermissionStatus _locationStatus = PermissionStatus.restricted;
  ServiceStatus _locationServiceStatus = ServiceStatus.notApplicable;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getLocationStatus();
    pages = [
      LocationThirdScreen(_nextPage),
      OnBoardingFirst(_nextPage, _previousPage),
      FeelInsecurity(_nextPage, _previousPage),
      //FeedFeature(_previousPage),
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getLocationStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff41045C),
      body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView(
                  controller: _pageController,
                  //physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(flex: 2, child: SizedBox.shrink()),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: 3,
                            effect: const SlideEffect(
                                spacing: 8.0,
                                radius: 15.0,
                                dotWidth: 30.0,
                                dotHeight: 8.0,
                                paintStyle: PaintingStyle.fill,
                                strokeWidth: 1.5,
                                dotColor: Color(0xffD09EE6),
                                activeDotColor: Colors.white),
                          ),
                          const Expanded(flex: 1, child: SizedBox.shrink()),
                          ElevatedButton(
                            onPressed: () {
                              int page = _pageController.page!.toInt();
                              if (page == 2) {
                                getIt<SharedPreferences>()
                                    .setBool('onboarding', true);
                                context.read<AuthCubit>().checkSignedInUser();
                              } else {
                                _pageController.animateToPage(page + 1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                              }
                            },
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8),
                              backgroundColor:
                                  const Color(0xff662383), // <-- Button color
                              foregroundColor:
                                  const Color(0xffD09EE6), // <-- Splash color
                            ),
                          )
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(20),
                                        right: Radius.circular(20))),
                                child: Text(
                                  AppLocalizations.of(context)!.join,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff662383),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                getIt<SharedPreferences>()
                                    .setBool('onboarding', true);
                                context.read<AuthCubit>().checkSignedInUser();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _nextPage(int index) async {
    await _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.decelerate,
    );
    setState(() {});
  }

  void _previousPage(int index) async {
    await _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.decelerate,
    );
    setState(() {});
  }

  Future<void> _getLocationStatus() async {
    final permissionStatus = await Permission.location.status;
    final serviceStatus = await Permission.location.serviceStatus;
    //setState(() {
    _locationStatus = permissionStatus;
    _locationServiceStatus = serviceStatus;
    //});

    debugPrint(_locationStatus.toString());
    switch (_locationStatus) {
      case PermissionStatus.granted:
        //buttonFunction = () async {
        if (_locationServiceStatus.isDisabled) {
          await DialogsHelper.locationDisabledDialog(context);
        }
        _getLocationAlwaysStatus();
        //widget._nextPage(2);
        //};
        break;
      case PermissionStatus.denied:
        //buttonFunction = () async {
        await Permission.location.request();
        await _getLocationStatus();
        //widget._nextPage(2);
        //};
        break;
      case PermissionStatus.permanentlyDenied:
        //buttonFunction = () async {
        await DialogsHelper.locationDeniedDialog(
          context,
          () async {
            await openAppSettings();
            getIt<NavigationService>().pop();
          },
        );
        //await _getLocationStatus();
        //};
        break;
      case PermissionStatus.restricted:
        //buttonFunction = () async {
        await Permission.location.request();
        await _getLocationStatus();
        //};
        break;
      default:
        break;
    }
  }

  Future<void> _getLocationAlwaysStatus() async {
    final permissionStatus = await Permission.locationAlways.status;
    //setState(() {
    _locationStatus = permissionStatus;
    //});

    debugPrint(_locationStatus.toString());
    switch (_locationStatus) {
      case PermissionStatus.granted:
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
}
