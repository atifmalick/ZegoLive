import 'dart:io';

import 'package:equatable/equatable.dart';

enum ContentType { image, audio, unknown }

class Content extends Equatable {
  final ContentType type;
  final String? url;
  final String? ext;
  final File? file;
  final String? mimeType;

  const Content({
    required this.type,
    this.url,
    this.ext,
    this.file,
    this.mimeType,
  });

  @override
  List<Object> get props => [];
}
