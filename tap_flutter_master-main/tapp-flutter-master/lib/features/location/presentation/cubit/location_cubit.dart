import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/services/location_service.dart';

part 'location_state.dart';

@lazySingleton
class LocationCubit extends Cubit<LocationState> {
  Timer? timer;
  StreamSubscription? _locationChangesSubscription;
  final LocationService _locationService;

  LocationCubit(this._locationService) : super(LocationInitial());

  Future<void> startLocation(String uid) async {
    if (!await _locationService.locationServiceEnabled) {
      emit(LocationNotEnabled());
    }
    _locationChangesSubscription = _locationService.getPositionStream().listen(
      (position) {
        emit(LocationUpdated(position));
      },
    );
  }

  void stopLocation() {
    _locationChangesSubscription?.cancel();
  }

  @override
  Future<void> close() {
    stopLocation();
    return super.close();
  }
}
