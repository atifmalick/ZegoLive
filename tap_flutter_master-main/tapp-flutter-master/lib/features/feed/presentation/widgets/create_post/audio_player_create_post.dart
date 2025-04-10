import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:tapp/core/themes/app_colors.dart';

typedef _Fn = void Function();

class AudioPlayerCreatePost extends StatefulWidget {
  const AudioPlayerCreatePost(
      {Key? key,
      required this.file,
      required this.uint8list,
      required this.removeAudio,
      this.id = 0})
      : super(key: key);
  final File file;
  final Uint8List uint8list;
  final Function removeAudio;

  final int? id;
  @override
  State<AudioPlayerCreatePost> createState() => _GalleryAudioState();
}

class _GalleryAudioState extends State<AudioPlayerCreatePost> {
  String savePath = "";
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mplaybackReady = false;
  StreamSubscription? _recorderSubscription;
  ValueNotifier<String> timer = ValueNotifier("00:00");

  String timee = "00:00";

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) async {
      await _mPlayer!
          .setSubscriptionDuration(const Duration(milliseconds: 125));

      setState(() {
        _mPlayerIsInited = true;
      });
    });
    setTime();
    super.initState();
  }

  setTime() {
    timer.value = "00:00";
    if (_mPlayer == null || _mPlayer!.onProgress == null) {
      return;
    }
    _mPlayer!.onProgress!.listen((e) {
      final duration = e.position;
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

      setState(() {
        timee = '$twoDigitMinutes:$twoDigitSeconds';
      });
    });
  }

  _Fn? reset() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return () {
      setState(() {
        _mRecorder?.stopRecorder();
        _mplaybackReady = false;
        cancelRecorderSubscriptions();
        timer.value = "00:00";
      });
    };
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  @override
  void dispose() {
    _mPlayer!.stopPlayer();
    _mPlayer = null;
    _mRecorder!.stopRecorder();
    _mRecorder = null;
    cancelRecorderSubscriptions();
    super.dispose();
  }

  void play() async {
    setTime();
    assert(_mPlayerIsInited &&
        // _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);

    _mPlayer!
        .startPlayer(
            fromDataBuffer: widget.uint8list,
            codec:
                //  kIsWeb ? Codec.opusWebM :
                Codec.defaultCodec,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  initializePlayer() async {
    await _mPlayer?.openPlayer();
  }

  // _Fn? getPlaybackFn() {
  //   if (!_mPlayerIsInited) {
  //     initializePlayer();
  //     return null;
  //   }
  //   return !_mPlayer!.isPlaying ? play : stopPlayer;
  // }
  _Fn? getPlaybackFn() {
    // log(widget.file);
    // if (widget.file! == null) {
    //   return null;
    // }
    if (!_mRecorder!.isStopped) {
      return null;
    }

    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  _Fn? sendAudio() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }

    return () {
      _showAlert('Sending audio... $savePath');
    };
  }

  _showAlert(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: AppColors.purple,
              ),
              onPressed: getPlaybackFn(),
              child: Icon(_mPlayer!.isPlaying ? Icons.stop : Icons.play_arrow),
            ),
          ),
          Center(
            child: Text(
              timee.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(30.0, 36.0),
                backgroundColor: Colors.white,
                textStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Icon(Icons.close),
              onPressed: () async {
                await widget.removeAudio();
              },
            ),
            // RaisedButton(
            //   shape: const CircleBorder(),
            //   color: Colors.white,
            //   textColor: Colors.black,
            //   child: const Icon(Icons.close),
            //   onPressed: () async {
            //     await widget.removeAudio();
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
