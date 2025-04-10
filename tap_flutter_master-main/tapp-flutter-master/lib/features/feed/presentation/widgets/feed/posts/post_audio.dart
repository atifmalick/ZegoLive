// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:tapp/core/themes/app_colors.dart';

// class PostAudio extends StatefulWidget {
//   final String audioUrl;

//   const PostAudio(this.audioUrl);

//   @override
//   _PostAudio createState() => _PostAudio();
// }

// class _PostAudio extends State<PostAudio> {
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
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           _buildPlayButton(),
//           Flexible(
//             child: LinearProgressIndicator(
//               backgroundColor: AppColors.black.withOpacity(0.3),
//               value: _audioPositionPercentage,
//               valueColor: AlwaysStoppedAnimation(AppColors.black),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             _audioDurationText,
//             style: TextStyle(
//               color: AppColors.black,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlayButton() {
//     IconData icon = Icons.play_arrow;
//     Function onPressed;

//     switch (_playerState) {
//       case AudioPlayerState.STOPPED:
//         icon = Icons.play_arrow_rounded;
//         onPressed = () async {
//           await _player.play(widget.audioUrl, isLocal: false);
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
//           await _player.play(widget.audioUrl, isLocal: false);
//         };
//         break;
//       default:
//         break;
//     }

//     return IconButton(
//       color: AppColors.black,
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
//       setState(
//         () => _audioDuration = duration,
//       );
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
