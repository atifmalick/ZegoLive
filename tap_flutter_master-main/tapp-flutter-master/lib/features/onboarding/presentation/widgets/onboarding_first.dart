import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapp/core/helpers/dialogs_helper.dart';
import 'package:tapp/core/themes/app_colors.dart';

class OnBoardingFirst extends StatefulWidget {
  final Function(int) _nextPage;
  final Function(int) _previousPage;

  const OnBoardingFirst(this._nextPage, this._previousPage, {Key? key})
      : super(key: key);

  @override
  _OnBoardingFirstState createState() => _OnBoardingFirstState();
}

class _OnBoardingFirstState extends State<OnBoardingFirst>
    with WidgetsBindingObserver {
  PermissionStatus _locationStatus = PermissionStatus.restricted;
  ServiceStatus _locationServiceStatus = ServiceStatus.notApplicable;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getLocationStatus();
    }
  }

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
          // Expanded(
          //   child: Text(
          //     // 'Tapp App as la única red gaosocial'
          //     // 'con GeoChat™ qua facilita la'
          //     // 'comunicación entre personas',
          //     //'Tapp app es la única red geosocial con GeoChat™ que facilita la comunicación entre personas',
          //     AppLocalizations.of(context)!.boarding_first_title,
          //     style: TextStyle(
          //       fontSize: 18,
          //       color: AppColors.black,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // Expanded(
          //   flex: 4,
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         top: 0.8,
          //         right: 25,
          //         child: Image.asset(
          //           'assets/photo1.png',
          //           width: 100,
          //         ),
          //       ),
          //       Positioned(
          //         top: 20,
          //         left: 15,
          //         child: ClipOval(
          //           child: Image.asset(
          //             'assets/photo2.png',
          //             width: 150,
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         bottom: 0.8,
          //         left: 30,
          //         child: ClipOval(
          //           child: Image.asset(
          //             'assets/photo3.png',
          //             width: 120,
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         bottom: 40,
          //         right: 0,
          //         child: ClipOval(
          //           child: Image.asset(
          //             'assets/photo4.png',
          //             width: 150,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   flex: 3,
          //   child: Column(
          //     children: [
          //       // Expanded(
          //       //   child: Text(
          //       //     //'con alcance geográfico en tiempo real desde su ubicación actual.',
          //       //     AppLocalizations.of(context)!.boarding_first_msg,
          //       //     style: TextStyle(
          //       //       fontSize: 18,
          //       //       color: AppColors.black,
          //       //       fontWeight: FontWeight.bold,
          //       //     ),
          //       //     textAlign: TextAlign.center,
          //       //   ),
          //       // ),
          //       Text(
          //         AppLocalizations.of(context)!.join_real_time,
          //         textAlign: TextAlign.center,
          //         style: const TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 25),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         child: Text(
          //           AppLocalizations.of(context)!.tapp_connect_other_app,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.w400,
          //               fontSize: 16),
          //         ),
          //       ),
          //       Text(
          //         AppLocalizations.of(context)!.no_one_can_see,
          //         textAlign: TextAlign.center,
          //         style: const TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w400,
          //             fontSize: 16),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/distance.png',
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocalizations.of(context)!.distance_filter,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  AppLocalizations.of(context)!.choose_radius_distance,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Flexible(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           elevation: 0,
          //           primary: AppColors.background,
          //           onPrimary: AppColors.purple,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //         child: Text(
          //           //'Atrás',
          //           AppLocalizations.of(context)!.btn_back,
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         onPressed: () => widget._previousPage(0),
          //       ),
          //       _buildSiguiente()
          //     ],
          //   ),
          // ),

          // Flexible(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Visibility(
          //         child: _buildNoActivateButton(),
          //         visible: false,
          //       ),
          //       _buildNextButton(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSiguiente() {
    Function buttonFunction = () {
      widget._nextPage(2);
    };

    debugPrint(_locationStatus.toString());
    switch (_locationStatus) {
      case PermissionStatus.granted:
        buttonFunction = () async {
          if (_locationServiceStatus.isDisabled) {
            await DialogsHelper.locationDisabledDialog(context);
          }
          widget._nextPage(2);
        };
        break;
      case PermissionStatus.denied:
        buttonFunction = () async {
          await Permission.location.request();
          await _getLocationStatus();
          widget._nextPage(2);
        };
        break;
      case PermissionStatus.permanentlyDenied:
        buttonFunction = () async {
          await DialogsHelper.locationDeniedDialog(
            context,
            () async => await openAppSettings(),
          );
          await _getLocationStatus();
        };
        break;
      case PermissionStatus.restricted:
        buttonFunction = () async {
          await Permission.location.request();
          await _getLocationStatus();
        };
        break;
      default:
        break;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple,
        textStyle: TextStyle(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        //'Siguiente',
        AppLocalizations.of(context)!.btn_continue,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () async => await buttonFunction(),
      // onPressed: () => widget._nextPage(2),
    );
  }

  Future<void> _getLocationStatus() async {
    final permissionStatus = await Permission.location.status;
    final serviceStatus = await Permission.location.serviceStatus;
    setState(() {
      _locationStatus = permissionStatus;
      _locationServiceStatus = serviceStatus;
    });
  }

  // Widget _buildNextButton() {
  //   Function buttonFunction = () {
  //     widget._nextPage(1);
  //   };
  //   String buttonText = 'Continuar';

  //   debugPrint(_locationStatus.toString());
  //   switch (_locationStatus) {
  //     case PermissionStatus.granted:
  //       buttonFunction = () async {
  //         if (_locationServiceStatus.isDisabled) {
  //           await DialogsHelper.locationDisabledDialog(context);
  //         }
  //         widget._nextPage(1);
  //       };
  //       break;
  //     case PermissionStatus.denied:
  //       buttonFunction = () async {
  //         await Permission.location.request();
  //         await _getLocationStatus();
  //         widget._nextPage(1);
  //       };
  //       break;
  //     case PermissionStatus.permanentlyDenied:
  //       buttonFunction = () async {
  //         await DialogsHelper.locationDeniedDialog(
  //           context,
  //           () async => await openAppSettings(),
  //         );
  //         await _getLocationStatus();
  //       };
  //       break;
  //     case PermissionStatus.restricted:
  //       buttonFunction = () async {
  //         await Permission.location.request();
  //         await _getLocationStatus();
  //       };
  //       break;
  //     default:
  //       break;
  //   }

  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       primary: AppColors.purple,
  //       textStyle: TextStyle(color: AppColors.purple),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     child: Text(
  //       buttonText,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     onPressed: () async => await buttonFunction(),
  //   );
  // }

  Widget _buildNoActivateButton() {
    if (!_locationStatus.isGranted) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(color: AppColors.purple),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.purple,
        ),
        child: const Text(
          'No activar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          widget._nextPage(2);
        },
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          textStyle: TextStyle(color: AppColors.purple),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const SizedBox(),
        onPressed: null,
      );
    }
  }
}
