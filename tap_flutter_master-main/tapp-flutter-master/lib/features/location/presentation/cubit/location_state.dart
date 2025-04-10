part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationUpdated extends LocationState {
  final Position position;

  const LocationUpdated(this.position);

  @override
  List<Object> get props => [position];
}

class LocationNotEnabled extends LocationState {}
