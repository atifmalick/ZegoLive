import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/location_service.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/location/presentation/cubit/location_cubit.dart';

class AlertMapScreen extends StatefulWidget {
  const AlertMapScreen({Key? key}) : super(key: key);

  @override
  _AlertMapScreenState createState() => _AlertMapScreenState();
}

class _AlertMapScreenState extends State<AlertMapScreen> {
  static const String _googleAPIKey = "AIzaSyCKCcvZIjFghu8soLcRR4UbOGqtOrQOvmc";
  late GoogleMapController _mapController;
  late Position _myPosition;

  late Position _alertPosition;

  late String _alertType = 'NORMAL';
  late CameraPosition _cameraPosition;
  late final Set<Marker> _markers = {};
  late List<Polyline> _polylines = [];

  @override
  void didChangeDependencies() {
    _alertPosition =
        (ModalRoute.of(context)!.settings.arguments as Map)['alertPosition'];
    _alertType =
        (ModalRoute.of(context)!.settings.arguments as Map)['alertType'];
    //print("${_alertPosition.longitude} LONG LAT ${_alertPosition.latitude}");
    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(
          _alertPosition.latitude,
          _alertPosition.longitude,
        ),
      );
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: _markers,
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(_alertPosition.latitude, _alertPosition.longitude)),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          scrollGesturesEnabled: true,
          mapType: MapType.normal,
          polylines: _polylines.toSet(),
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            _mapController = controller;
            await _initMap();
            await _initRoutePolilyne();
            _setAlertMarker();
            _moveCamera();
          },
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 6,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: AppColors.purple,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  child: _buildTitle(),
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(
                  AppLocalizations.of(context)!.exit_map,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  getIt<NavigationService>().pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    String title = "";

    switch (_alertType) {
      case "NORMAL":
        title = AppLocalizations.of(context)!.there_is_person_danger_near_you;
        break;
      case "GUN_RISK":
        title = AppLocalizations.of(context)!.person_calling;
        break;
      case "DOMESTIC":
        title = AppLocalizations.of(context)!.person_asking;
        break;
      default:
    }

    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.white,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _initMap() async {
    Position position;
    final locationState = context.read<LocationCubit>().state;

    // Initialize my position
    if (locationState is LocationUpdated) {
      position = locationState.position;
    } else {
      position = await getIt<LocationService>().getPosition();
    }

    setState(() => _myPosition = position);
  }

  void _setAlertMarker() {
    // Set the alertMarker on the map
    Marker alertMarker = Marker(
      markerId: const MarkerId('alert'),
      position: LatLng(
        _alertPosition.latitude,
        _alertPosition.longitude,
      ),
      infoWindow: InfoWindow(
        title: AppLocalizations.of(context)!.distress_alert,
        snippet: AppLocalizations.of(context)!.approx_location,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() => _markers.add(alertMarker));
  }

  void _moveCamera() {
    Position southwestCoordinates;
    Position northeastCoordinates;

    // Compare two positions to set northeast and southwest
    // to move camera to a place with the two positions centered

    setState(() {
      if (_myPosition.latitude <= _alertPosition.latitude) {
        southwestCoordinates = _myPosition;
        northeastCoordinates = _alertPosition;
      } else {
        southwestCoordinates = _alertPosition;
        northeastCoordinates = _myPosition;
      }

      // Set bounds to calculate the center of two positions
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          southwestCoordinates.latitude,
          southwestCoordinates.longitude,
        ),
        northeast: LatLng(
          northeastCoordinates.latitude,
          northeastCoordinates.longitude,
        ),
      );

      // Calculate the center of the two positions
      LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      _cameraPosition = CameraPosition(
        target: centerBounds,
        zoom: 15,
      );

      // Move camera to the new position
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(_cameraPosition),
      );
    });
  }

  Future<void> _initRoutePolilyne() async {
    final polylinePoints = await PolylinePoints().getRouteBetweenCoordinates(
        _googleAPIKey,
        PointLatLng(_myPosition.latitude, _myPosition.longitude),
        PointLatLng(_alertPosition.latitude, _alertPosition.longitude));

    final points = polylinePoints.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    setState(() {
      _polylines = [
        Polyline(
          polylineId: const PolylineId("route"),
          width: 5,
          color: AppColors.purple,
          points: points,
        )
      ];
    });
  }
}
