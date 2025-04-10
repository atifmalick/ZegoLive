import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  final File? _photo;
  final Function _removePhoto;

  const PhotoPreview(this._photo, this._removePhoto, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_photo != null && _photo!.existsSync()) {
      return Stack(
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _photo!,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: (MediaQuery.of(context).size.width * 0.05) - 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Icon(Icons.close),
              onPressed: () async {
                await _removePhoto();
              },
            ),
          ),
        ],
      );
    }

    return Container();
  }
}
