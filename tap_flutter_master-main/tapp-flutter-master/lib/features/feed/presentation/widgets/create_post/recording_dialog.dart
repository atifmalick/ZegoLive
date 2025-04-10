import 'dart:async';
import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class RecordingDialog extends StatefulWidget {
  final Function(File, {ContentType contentType}) setAudio;

  const RecordingDialog(this.setAudio, {Key? key}) : super(key: key);

  @override
  _RecordingDialogState createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  late AnotherAudioRecorder _recorder;
  Recording _current = Recording();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeRecorder();
      await _startRecording();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAudioWave(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            _buildDuration(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        MaterialButton(
          height: 48,
          elevation: 0,
          shape: const CircleBorder(),
          color: AppColors.red.withOpacity(0.25),
          textColor: AppColors.red,
          splashColor: AppColors.red,
          child: const Icon(Icons.stop_rounded, size: 30),
          onPressed: () async {
            await _stopRecording();
            getIt<NavigationService>().pop();
          },
        ),
      ],
    );
  }

  Widget _buildAudioWave() {
    final List<AudioWaveBar> bars = [
      AudioWaveBar(
        heightFactor: 20,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 80,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 20,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 80,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 20,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 80,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 20,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 80,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 60,
        radius: 10,
        color: AppColors.red,
      ),
      AudioWaveBar(
        heightFactor: 40,
        radius: 10,
        color: AppColors.red,
      ),
    ];

    return AudioWave(
      animation: true,
      beatRate: const Duration(milliseconds: 100),
      spacing: 5,
      bars: bars,
    );
  }

  String _buildDuration() {
    if (_current.duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes =
          twoDigits(_current.duration!.inMinutes.remainder(60));
      String twoDigitSeconds =
          twoDigits(_current.duration!.inSeconds.remainder(60));
      return '$twoDigitMinutes:$twoDigitSeconds';
    }

    return '00:00';
  }

  Future<void> _initializeRecorder() async {
    try {
      final bool? permission = await AnotherAudioRecorder.hasPermissions;

      if (permission == null || !permission) {
        return SnackbarHelper.failureSnackbar(
                AppLocalizations.of(context)!.error_occur,
                AppLocalizations.of(context)!.permission_audio)
            .show(context);
      }

      Directory? directory;
      // Set directory depending on platform
      directory = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      // print(directory);
      // Set final path for audio with name and extension
      String finalPath =
          '${directory!.path}/${DateHelper.currentTimestamp()}.wav';

      // Create the recorder
      _recorder = AnotherAudioRecorder(
        finalPath,
        audioFormat: AudioFormat.WAV,
      );

      // Initialize the recorder
      await _recorder.initialized;
      _current = (await _recorder.current(channel: 0))!;

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (_current.status == RecordingStatus.Stopped ||
          _current.status == RecordingStatus.Unset) {
        await _initializeRecorder();
      }

      // Start recording
      await _recorder.start();

      // Check every 50 milliseconds the status of recording
      Timer.periodic(const Duration(milliseconds: 50), (Timer t) async {
        if (_current.status == RecordingStatus.Stopped) {
          t.cancel();
        }
        _current = (await _recorder.current(channel: 0))!;

        setState(() {});
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      _current = (await _recorder.stop())!;
      setState(() {});
      File f = File(_current.path!);

      await widget.setAudio(f, contentType: ContentType.audio);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
