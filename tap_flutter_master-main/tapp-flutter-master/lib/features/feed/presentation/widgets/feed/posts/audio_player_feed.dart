import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:tapp/core/themes/app_colors.dart';

typedef _Fn = void Function();

class MyAudioFeed extends StatefulWidget {
  const MyAudioFeed({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<MyAudioFeed> createState() => _GalleryAudioState();
}

class _GalleryAudioState extends State<MyAudioFeed> {
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
            fromURI: widget.url,
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
    return Container(
      width: 95,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(6),
                backgroundColor: AppColors.purple,
              ),
              onPressed: getPlaybackFn(),
              child: Icon(_mPlayer!.isPlaying ? Icons.stop : Icons.play_arrow),
            ),
          ),
          Center(
            child: Text(
              timee.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:tapp/core/themes/app_colors.dart';

// typedef _Fn = void Function();

// class MyAudioFeed extends StatefulWidget {
//   const MyAudioFeed({Key? key, required this.url}) : super(key: key);
//   final String url;
//   @override
//   State<MyAudioFeed> createState() => _MyAudioFeedState();
// }

// class _MyAudioFeedState extends State<MyAudioFeed> {
//   String savePath = "";
//   FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   // final bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;
//   StreamSubscription? _recorderSubscription;
//   ValueNotifier<String> timer = ValueNotifier("00:00");

//   String timee = "00:00";

//   @override
//   void initState() {
//     // ensureInitializationComplete();
//     _mPlayer!.openPlayer().then((value) async {
//       await _mPlayer!
//           .setSubscriptionDuration(const Duration(milliseconds: 125));

//       setState(() {
//         _mPlayerIsInited = true;
//       });
//     });
//     setTime();
//     super.initState();
//   }

//   setTime() {
//     timer.value = "00:00";

//     _mPlayer!.onProgress!.listen((e) {
//       final duration = e.position;
//       // String twoDigits(int n) => n.toString().padLeft(2, '0').substring(0, 2);
//       String twoDigits(int n) => n.toString().padLeft(2, '0').substring(0, 2);
//       final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

//       final twoDigitMilliSeconds =
//           twoDigits(duration.inMilliseconds.remainder(60));
//       setState(() {
//         timee = "$twoDigitSeconds:$twoDigitMilliSeconds";
//       });
//       timer.value = "$twoDigitSeconds:$twoDigitMilliSeconds";
//       // if (twoDigitSeconds == "30") {
//       // setState(() {
//       //   timer.value = "$twoDigitSeconds:00";
//       // });
//       // }
//     });
//   }

//   _Fn? reset() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
//       return null;
//     }
//     return () {
//       setState(() {
//         _mRecorder?.stopRecorder();
//         _mplaybackReady = false;
//         cancelRecorderSubscriptions();
//         timer.value = "00:00";
//       });
//     };
//   }

//   void cancelRecorderSubscriptions() {
//     if (_recorderSubscription != null) {
//       _recorderSubscription!.cancel();
//       _recorderSubscription = null;
//     }
//   }

//   @override
//   void dispose() {
//     _mPlayer!.stopPlayer();
//     _mPlayer = null;
//     _mRecorder!.stopRecorder();
//     _mRecorder = null;
//     cancelRecorderSubscriptions();
//     super.dispose();
//   }

//   void play() async {
//     assert(_mPlayerIsInited &&
//         // _mplaybackReady &&
//         _mRecorder!.isStopped &&
//         _mPlayer!.isStopped);

//     _mPlayer!
//         .startPlayer(
//             fromURI: widget.url,
//             // fromDataBuffer: widget.uint8list,
//             codec:
//                 //  kIsWeb ? Codec.opusWebM :
//                 Codec.defaultCodec,
//             whenFinished: () {
//               setState(() {});
//             })
//         .then((value) {
//       setState(() {});
//     });
//   }

//   void stopPlayer() {
//     _mPlayer!.stopPlayer().then((value) {
//       setState(() {});
//     });
//   }

//   initializePlayer() async {
//     await _mPlayer?.openPlayer();
//   }

//   // _Fn? getPlaybackFn() {
//   //   if (!_mPlayerIsInited) {
//   //     initializePlayer();
//   //     return null;
//   //   }
//   //   return !_mPlayer!.isPlaying ? play : stopPlayer;
//   // }
//   _Fn? getPlaybackFn() {
//     // log(widget.file);
//     // if (widget.file! == null) {
//     //   return null;
//     // }
//     if (!_mRecorder!.isStopped) {
//       return null;
//     }

//     return _mPlayer!.isStopped ? play : stopPlayer;
//   }

//   _Fn? sendAudio() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
//       return null;
//     }

//     return () {
//       _showAlert('Sending audio... $savePath');
//     };
//   }

//   _showAlert(String message) {
//     SnackBar snackBar = SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 1),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 95,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(left: 10),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: const CircleBorder(),
//                 padding: const EdgeInsets.all(14),
//                 primary: AppColors.purple,
//                 onPrimary: Colors.white,
//               ),
//               onPressed: getPlaybackFn(),
//               child: Icon(_mPlayer!.isPlaying ? Icons.stop : Icons.play_arrow),
//             ),
//           ),
//           Center(
//             child: Text(
//               timee.toString(),
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
