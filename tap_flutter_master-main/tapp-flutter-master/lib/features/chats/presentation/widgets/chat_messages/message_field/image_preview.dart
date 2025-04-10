import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImagePreview extends StatelessWidget {
  final Content _content;
  final Function()? _removeImage;

  const ImagePreview(this._content, this._removeImage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: decodeImageFromList(_content.file!.readAsBytesSync()),
      builder: (context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _content.file!,
                      cacheHeight: snapshot.data!.height ~/ 5,
                      cacheWidth: snapshot.data!.width ~/ 5,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      color: Colors.red[400],
                    ),
                  ),
                  icon: const Icon(Ionicons.trash, size: 20),
                  label: Text(
                    AppLocalizations.of(context)!.remove_image,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: _removeImage,
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
