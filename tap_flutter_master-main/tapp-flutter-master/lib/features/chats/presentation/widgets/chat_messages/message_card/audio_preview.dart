// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class AudioPreview extends StatefulWidget {
//   final String url;
//   final Color textColor;

//   const AudioPreview({
//     @required this.url,
//     @required this.textColor,
//   });

//   @override
//   _AudioPreviewState createState() => _AudioPreviewState();
// }

// class _AudioPreviewState extends State<AudioPreview> {
//   AudioPlayer _player = AudioPlayer();
//   AudioPlayerState _playerState = AudioPlayerState.STOPPED;
//   Duration _audioDuration = Duration(seconds: 0);
//   String _audioDurationText = '0:00:00';
//   double _audioPositionPercentage = 0.0;

//   StreamSubscription _durationSubscription;
//   StreamSubscription _positionSubscription;
//   StreamSubscription _stateSubscription;

//   @override
//   void initState() {
//     _listenAudioDuration();
//     _listenAudioPosition();
//     _listenAudioPlayerState();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _durationSubscription.cancel();
//     _positionSubscription.cancel();
//     _stateSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: Row(
//         children: [
//           _buildPlayButton(),
//           Flexible(
//             child: LinearProgressIndicator(
//               backgroundColor: widget.textColor.withOpacity(0.2),
//               value: _audioPositionPercentage,
//               valueColor: AlwaysStoppedAnimation(
//                 widget.textColor.withOpacity(0.8),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             _audioDurationText,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//               color: widget.textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlayButton() {
//     IconData icon = Icons.play_arrow_rounded;
//     Function onPressed = () async {
//       await _player.play(widget.url);
//     };

//     if (_playerState == AudioPlayerState.PLAYING) {
//       icon = Icons.pause_rounded;
//       onPressed = () async {
//         await _player.pause();
//       };
//     }

//     return IconButton(
//       color: widget.textColor,
//       icon: Icon(icon),
//       onPressed: onPressed,
//     );
//   }

//   void _listenAudioDuration() {
//     _durationSubscription =
//         _player.onDurationChanged.listen((Duration duration) {
//       if (_audioDuration.inSeconds == 0) {
//         setState(() {
//           final string = duration.toString();
//           _audioDuration = duration;
//           _audioDurationText = string.substring(
//             0,
//             string.lastIndexOf('.'),
//           );
//         });
//       }
//     });
//   }

//   void _listenAudioPosition() {
//     _positionSubscription =
//         _player.onAudioPositionChanged.listen((Duration position) {
//       setState(() {
//         final seconds = _audioDuration.inSeconds - position.inSeconds;
//         final string = Duration(seconds: seconds).toString();
//         _audioPositionPercentage =
//             ((position.inSeconds * 100) / _audioDuration.inSeconds) / 100;
//         _audioDurationText = string.substring(
//           0,
//           string.lastIndexOf('.'),
//         );
//       });
//     });
//   }

//   void _listenAudioPlayerState() {
//     _stateSubscription =
//         _player.onPlayerStateChanged.listen((AudioPlayerState state) {
//       setState(() {
//         if (state == AudioPlayerState.STOPPED ||
//             state == AudioPlayerState.COMPLETED) {
//           _audioDurationText = _audioDuration.toString().substring(
//                 0,
//                 _audioDuration.toString().lastIndexOf('.'),
//               );
//           _audioPositionPercentage = 0.0;
//           _audioDuration = Duration(seconds: 0);
//         }

//         _playerState = state;
//       });
//     });
//   }
// }
