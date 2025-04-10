import 'dart:io';

import 'package:tapp/features/feed/domain/entities/content.dart';

class ContentModel extends Content {
  const ContentModel({
    required String url,
    required ContentType type,
    String? ext,
    File? file,
    String? mimeType,
  }) : super(
          url: url,
          type: type,
          file: file,
          ext: ext,
          mimeType: mimeType,
        );

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      url: json['url'] ?? '',
      type: parseContentType(json['contentType']),
      ext: parseContentExtension(json['contentType']),
    );
  }
}

ContentType parseContentType(String? contentType) {
  if (contentType == null) return ContentType.unknown;

  if (contentType.contains('image')) return ContentType.image;

  if (contentType.contains('audio')) return ContentType.audio;

  return ContentType.unknown;
}

String parseContentExtension(String? contentType) {
  if (contentType == null) return '';
  if (contentType.isNotEmpty == true) return "." + contentType.split('/').last;

  return "";
}
