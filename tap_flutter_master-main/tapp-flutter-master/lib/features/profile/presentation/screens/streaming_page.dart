import 'dart:async';
import 'dart:developer';
import 'package:tapp/features/home/presentation/screens/home_screen.dart';
import 'package:uuid/uuid.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/live_status.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/feed/presentation/cubit/delete_post/delete_post_cubit.dart';
import 'package:tapp/live_stream_cubit.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String username;
  final String userId;
  final String liveStremId;
  final bool executeFunction;
  final double? lat;
  final double? long;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
    required this.username,
    required this.userId,
    required this.liveStremId,
    required this.executeFunction,
    this.lat,
    this.long,
  }) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with WidgetsBindingObserver {
  int _remainingTime = 60;
  late Timer _timer;
  bool _isStreamStarted = false;
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.executeFunction) {
      _startLive();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    if (widget.isHost) {
      _endLiveStream(false);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        log("App is in background");
        _endLiveStream(true);
        break;
      case AppLifecycleState.resumed:
        _endLiveStream(true);
        break;
      case AppLifecycleState.detached:
        log("App is terminated");
        _endLiveStream(true);
        break;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime == 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Your live stream will end in 10 seconds.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          _timer.cancel();
          _endLiveStream(true);
        }
      });
    });
  }

  _startLive() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();

    final input = {
      'userId': widget.userId,
      'streamingID': widget.liveStremId, // Using the passed UUID directly
      "userToken": token,
      "message": widget.liveID, // Using the same UUID for message/liveID
      "coordinates": {"latitude": widget.lat, "longitude": widget.long}
    };

    final data = await context.read<LiveStreamCubit>().startNewStream(input);
    log(widget.liveID, name: "StreamingId");
    await Preferences.setLiveStreamData(true, data['postId']);

    if (widget.isHost) {
      _startTimer();
    }
  }

  _endLiveStream(bool goBack) async {
    await Preferences.setLiveStreamData(false, "");

    if (goBack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your live stream has ended due to the 60-second time limit.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            onDispose: () => _endLiveStream(true),
            appID: 127840469,
            appSign: 'a003db32a8537416d39ca72b7de4bfd5d35bbd3addba81e865b152673fc7ce60',
            userID: widget.liveStremId, // Using the UUID
            userName: widget.username,
            liveID: widget.liveID, // Using the same UUID
            config: widget.isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          ),
          Positioned(
            bottom: 200,
            right: 10,
            child: Image.asset(
              'assets/watermark.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}