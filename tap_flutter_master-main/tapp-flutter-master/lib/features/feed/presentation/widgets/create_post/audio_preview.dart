// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:tapp/core/themes/app_colors.dart';

// class AudioPreview extends StatefulWidget {
//   final File file;
//   final Function removeAudio;

//   const AudioPreview(this.file, this.removeAudio);

//   @override
//   _AudioPreview createState() => _AudioPreview();
// }

// class _AudioPreview extends State<AudioPreview> {
//   final AudioPlayer _player = AudioPlayer();
//   // AudioPlayerState _playerState = AudioPlayerState.STOPPED;
//   final Duration _audioDuration = const Duration(seconds: 0);
//   String _audioDurationText = '00:00';
//   double _audioPositionPercentage = 0.0;

//   @override
//   void initState() {
//     _player.setReleaseMode(ReleaseMode.release);
//     // _player.setSourceDeviceFile(widget.file.path);
//     _onStateChanged();
//     _onDurationChanged();
//     _onPositionChanged();
//     _onCompletionEvent();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topRight,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.purple,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.symmetric(vertical: 30),
//           padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
//           height: 96,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               _buildPlayButton(),
//               Flexible(
//                 child: LinearProgressIndicator(
//                   backgroundColor: AppColors.white.withOpacity(0.3),
//                   value: _audioPositionPercentage,
//                   valueColor: AlwaysStoppedAnimation(AppColors.white),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 _audioDurationText,
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Align(
//           alignment: const Alignment(1.25, 0),
//           child: RaisedButton(
//             shape: const CircleBorder(),
//             color: Colors.white,
//             textColor: Colors.black,
//             child: const Icon(Icons.close),
//             onPressed: () async {
//               await widget.removeAudio();
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPlayButton() {
//     IconData icon = Icons.play_arrow;
//     void Function()? onPressed;

//     switch (_player.state) {
//       case PlayerState.stopped:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.play(DeviceFileSource(widget.file.path));
//         };
//         break;
//       case PlayerState.playing:
//         icon = Icons.pause_rounded;
//         onPressed = () async {
//           await _player.pause();
//         };
//         break;
//       case PlayerState.paused:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.resume();
//         };
//         break;
//       case PlayerState.completed:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           // await _player.play();
//           await _player.play(DeviceFileSource(widget.file.path));
//           // await _player.seek(const Duration(seconds: 0));
//           // await _player.play(widget.file.path);
//         };
//         break;
//       default:
//         break;
//     }

//     return IconButton(
//       color: AppColors.white,
//       icon: Icon(icon),
//       onPressed: onPressed,
//     );
//   }

//   void _onStateChanged() {
//     _player.onPlayerStateChanged.listen((PlayerState state) {
//       setState(() => _player.state = state);
//     });
//   }

//   void _onPositionChanged() {
//     _player.onPositionChanged.listen((Duration position) {
//       setState(() {
//         _audioPositionPercentage =
//             ((position.inMilliseconds * 100) / _audioDuration.inMilliseconds) /
//                 100;
//         _audioDurationText = _formatDuration(position);
//       });
//     });
//   }

//   void _onDurationChanged() {
//     _player.onDurationChanged.listen((Duration duration) {
//       setState(() {
//         // _audioDuration = duration;
//         _audioDurationText = _formatDuration(duration);
//       });
//     });
//   }

//   void _onCompletionEvent() {
//     _player.onPlayerComplete.listen((event) async {
//       await _player.release();
//       setState(() => _audioDurationText = _formatDuration(_audioDuration));
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';

//     return '00:00';
//   }
// }
