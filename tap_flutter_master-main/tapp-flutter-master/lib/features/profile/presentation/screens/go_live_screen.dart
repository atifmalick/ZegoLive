import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/Static/cordinates.dart';
import 'package:tapp/core/helpers/live_status.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/screens/streaming_page.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({Key? key}) : super(key: key);

  @override
  State<GoLivePage> createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  bool alreadyStreaming = false;
  final Uuid _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 199, 33, 228), Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Share your moments with the world in real-time',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  LiveBenefitTile(
                    icon: Icons.people,
                    text: 'Engage with your followers instantly',
                  ),
                  LiveBenefitTile(
                    icon: Icons.share,
                    text: 'Share your experiences as they happen',
                  ),
                  LiveBenefitTile(
                    icon: Icons.feedback,
                    text: 'Get real-time feedback and comments',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                bool isLiveStreamOn = await Preferences.getLiveStreamOn();
                await AppCordinates.getCurrentLocation(context);
                if (AppCordinates.lat == 0.0 || AppCordinates.long == 0.0) {
                  AppCordinates.showToast(context,
                      "Location services are disabled. Please enable them in settings.");
                  return;
                }

                // Generate a single UUID for both IDs
                final liveId = _uuid.v4();

                if (Platform.isAndroid) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LivePage(
                      lat: AppCordinates.lat,
                      long: AppCordinates.long,
                      executeFunction: isLiveStreamOn ? false : true,
                      liveStremId: liveId, // Using the UUID
                      userId: user.uid.toString(),
                      username: user.username.toString(),
                      liveID: liveId, // Using the same UUID
                      isHost: true,
                    ),
                  ));
                } else {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => LivePage(
                      lat: AppCordinates.lat,
                      long: AppCordinates.long,
                      executeFunction: isLiveStreamOn ? false : true,
                      liveStremId: liveId, // Using the UUID
                      userId: user.uid.toString(),
                      username: user.username.toString(),
                      liveID: liveId, // Using the same UUID
                      isHost: true,
                    ),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                alreadyStreaming
                    ? AppLocalizations.of(context)!.continue_streaming
                    : AppLocalizations.of(context)!.go_live_now,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveBenefitTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const LiveBenefitTile({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}