import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              'assets/tappss.png',
              height: 128,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context)!.splash_screen_title),
            ),
          ],
        ),
      ),
    );
  }
}
