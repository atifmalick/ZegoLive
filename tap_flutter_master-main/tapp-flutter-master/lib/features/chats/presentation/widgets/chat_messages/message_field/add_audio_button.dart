import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        backgroundColor: AppColors.red.withOpacity(0.3),
        padding: const EdgeInsets.all(10),
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
                  title: Text(
                    AppLocalizations.of(context)!.recording_audio,
                    style: const TextStyle(
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
