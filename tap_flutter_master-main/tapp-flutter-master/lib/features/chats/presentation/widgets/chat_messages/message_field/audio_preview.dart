// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:tapp/core/themes/app_colors.dart';

// class AudioPreview extends StatefulWidget {
//   final File file;
//   final Function removeAudio;

//   const AudioPreview(this.file, this.removeAudio);

//   @override
//   _AudioPreview createState() => _AudioPreview();
// }

// class _AudioPreview extends State<AudioPreview> {
//   AudioPlayer _player = AudioPlayer();
//   AudioPlayerState _playerState = AudioPlayerState.STOPPED;
//   Duration _audioDuration = Duration(seconds: 0);
//   String _audioDurationText = '00:00';
//   double _audioPositionPercentage = 0.0;

//   @override
//   void initState() {
//     _player.setReleaseMode(ReleaseMode.RELEASE);
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
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.purple,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
//           padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
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
//         FlatButton.icon(
//           textColor: Colors.red[400],
//           icon: Icon(Ionicons.trash, size: 20),
//           label: Text(
//             'Quitar audio',
//             style: TextStyle(fontSize: 12),
//           ),
//           onPressed: widget.removeAudio,
//         ),
//       ],
//     );
//   }

//   Widget _buildPlayButton() {
//     IconData icon = Icons.play_arrow;
//     Function onPressed;

//     switch (_playerState) {
//       case AudioPlayerState.STOPPED:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.play(widget.file.path, isLocal: true);
//         };
//         break;
//       case AudioPlayerState.PLAYING:
//         icon = Icons.pause_rounded;
//         onPressed = () async {
//           await _player.pause();
//         };
//         break;
//       case AudioPlayerState.PAUSED:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.resume();
//         };
//         break;
//       case AudioPlayerState.COMPLETED:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.play(widget.file.path, isLocal: true);
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
//     _player.onPlayerStateChanged.listen((AudioPlayerState state) {
//       setState(() => _playerState = state);
//     });
//   }

//   void _onPositionChanged() {
//     _player.onAudioPositionChanged.listen((Duration position) {
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
//         _audioDuration = duration;
//         // _audioDurationText = _formatDuration(duration);
//       });
//     });
//   }

//   void _onCompletionEvent() {
//     _player.onPlayerCompletion.listen((event) async {
//       await _player.release();
//       setState(() => _audioDurationText = _formatDuration(_audioDuration));
//     });
//   }

//   String _formatDuration(Duration duration) {
//     if (duration != null) {
//       String twoDigits(int n) => n.toString().padLeft(2, "0");
//       String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//       String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//       return '$twoDigitMinutes:$twoDigitSeconds';
//     }

//     return '00:00';
//   }
// }
