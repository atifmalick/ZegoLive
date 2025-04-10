// import 'dart:io';
// import 'dart:typed_data';

// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:tapp/core/themes/app_colors.dart';

// class MyAudioPlayer extends StatefulWidget {
//   const MyAudioPlayer(
//       {required this.uint8list,
//       required this.file,
//       required this.removeAudio,
//       Key? key})
//       : super(key: key);
//   final File file;
//   final Function removeAudio;
//   final Uint8List uint8list;

//   @override
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<MyAudioPlayer> with WidgetsBindingObserver {
//   final _player = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     _init();
//   }

//   Future<void> _init() async {
//     print("++++++++******************");
//     try {
//       final session = await AudioSession.instance;
//       await session.configure(const AudioSessionConfiguration.speech());
//       // Listen to errors during playback.
//       _player.playbackEventStream.listen((event) {},
//           onError: (Object e, StackTrace stackTrace) {
//         print('A stream error occurred: $e');
//       });
//       // Try to load audio from a source and catch any errors.
//       print("++++++++");
//       print(widget.file.path);
//       await _player.setAudioSource(AudioSource.uri(Uri.file(widget.file.path)));
//     } catch (e) {
//       print("Error loading audio source: $e");
//     }
//   }

//   @override
//   void dispose() {
//     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
//     // Release decoders and buffers back to the operating system making them
//     // available for other apps to use.
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _player.stop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ControlButtons(_player, widget.removeAudio);
//   }
// }

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//   const ControlButtons(this.player, this.removeAudio, {Key? key})
//       : super(key: key);
//   final Function removeAudio;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 StreamBuilder<Duration>(
//                     stream: player.positionStream,
//                     builder: (context, snapshot) {
//                       // print(snapshot.data);
//                       int d = 0;
//                       if (snapshot.hasData) {
//                         d = snapshot.data!.inMilliseconds;
//                       }
//                       DateTime date = DateTime.fromMillisecondsSinceEpoch(d);
//                       String txt = DateFormat('ss:SS', 'en_US').format(date);

//                       return Padding(
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Text(
//                           txt,
//                           style: const TextStyle(
//                               fontSize: 25, fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     })
//               ],
//             )),
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             Duration d = player.position;
//             if (processingState == ProcessingState.completed) {
//               d = Duration.zero;
//               // player.seek(Duration.zero);
//               // player.position = Duration.zero;
//             }
//             return Row(
//               children: [
//                 (processingState == ProcessingState.loading ||
//                         processingState == ProcessingState.buffering)
//                     ? audioWidget(() {}, Icons.play_arrow)
//                     : ((playing != true)
//                         ? audioWidget(player.play, Icons.play_arrow)
//                         : ((processingState != ProcessingState.completed)
//                             ? audioWidget(player.pause, Icons.pause)
//                             : audioWidget(() => player.seek(Duration.zero),
//                                 Icons.play_arrow))),
//                 audioWidget(
//                     d == Duration.zero
//                         ? () {}
//                         : () => player.seek(Duration.zero),
//                     Icons.replay,
//                     color: d == Duration.zero ? Colors.grey : null),
//                 // Text(d.inMilliseconds.toString())

//                 Align(
//                   alignment: const Alignment(1.25, 0),
//                   child: RaisedButton(
//                     shape: const CircleBorder(),
//                     color: Colors.white,
//                     textColor: Colors.black,
//                     child: const Icon(Icons.close),
//                     onPressed: () async {
//                       await removeAudio();
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget audioWidget(fn, iconData, {Color? color}) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         shape: const CircleBorder(),
//         padding: const EdgeInsets.all(14),
//         primary: color ?? AppColors.purple,
//         onPrimary: Colors.white,
//       ),
//       onPressed: fn,
//       child: Icon(
//         iconData,
//         size: 16,
//       ),
//     );
//   }

//   Widget audioLoadingWidget() {
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: const CircleBorder(),
//           padding: const EdgeInsets.all(14),
//           primary: AppColors.purple,
//           onPrimary: Colors.white,
//         ),
//         onPressed: () {},
//         child: const SizedBox(
//           height: 8.0,
//           width: 8.0,
//           child: CircularProgressIndicator(
//             strokeWidth: 0.5,
//             color: Colors.white,
//           ),
//         ));
//   }
// }
