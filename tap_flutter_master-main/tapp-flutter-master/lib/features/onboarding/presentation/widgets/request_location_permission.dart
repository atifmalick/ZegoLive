import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapp/core/helpers/dialogs_helper.dart';
import 'package:tapp/core/themes/app_colors.dart';

class RequestLocationPermission extends StatefulWidget {
  final Function(int) _nextPage;

  const RequestLocationPermission(this._nextPage, {Key? key}) : super(key: key);

  @override
  _RequestLocationPermissionState createState() =>
      _RequestLocationPermissionState();
}

class _RequestLocationPermissionState extends State<RequestLocationPermission>
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
          Expanded(
            flex: 2,
            child: Image.asset('assets/location.png'),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.using_your_loc,
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
                    AppLocalizations.of(context)!.send_help_alert,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  child: _buildNoActivateButton(),
                  visible: false,
                ),
                _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildNextButton() {
    Function buttonFunction = () {
      widget._nextPage(1);
    };
    String buttonText = AppLocalizations.of(context)!.btn_continue;

    // debugPrint(_locationStatus.toString());
    switch (_locationStatus) {
      case PermissionStatus.granted:
        buttonFunction = () async {
          if (_locationServiceStatus.isDisabled) {
            await DialogsHelper.locationDisabledDialog(context);
          }
          widget._nextPage(1);
        };
        break;
      case PermissionStatus.denied:
        buttonFunction = () async {
          await Permission.location.request();
          await _getLocationStatus();
          widget._nextPage(1);
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
        textStyle: TextStyle(color: AppColors.purple),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () async => await buttonFunction(),
    );
  }

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
        child: Text(
          AppLocalizations.of(context)!.do_not_active,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          widget._nextPage(1);
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
