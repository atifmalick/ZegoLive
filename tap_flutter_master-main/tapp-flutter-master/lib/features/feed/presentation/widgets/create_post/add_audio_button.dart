import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/recording_dialog.dart';

class AddAudioButton extends StatelessWidget {
  final Function(File, {ContentType contentType}) _setAudio;

  const AddAudioButton(this._setAudio, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.red,
        minimumSize: const Size(125, 40),
        backgroundColor: AppColors.red.withOpacity(0.3),
      ),
      icon: const Icon(Icons.mic_rounded, size: 20),
      label: const Text(
        'Audio',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text(
                    'Grabando audio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: RecordingDialog(_setAudio),
                );
              },
            );
          },
        );
      },
    );
  }
}
