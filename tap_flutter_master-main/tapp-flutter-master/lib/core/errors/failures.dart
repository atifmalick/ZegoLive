// ignore_for_file: annotate_overrides, overridden_fields

import 'package:equatable/equatable.dart';

// Failures when Firebase or Tapp Server returns an exception

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class GraphqlFailure extends Failure {
  final String message;

  const GraphqlFailure(this.message) : super(message);

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class FirebaseFailure extends Failure {
  @override
  final String message;

  const FirebaseFailure(this.message) : super(message);

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class ImagePickerFailure extends Failure {
  @override
  final String message;

  const ImagePickerFailure(this.message) : super(message);

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
