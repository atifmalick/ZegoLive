import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostUserVerified extends StatelessWidget {
  const PostUserVerified({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.regional_account,
      preferBelow: false,
      child: Icon(
        Icons.verified,
        size: MediaQuery.of(context).size.width > 600 ? 20 : 15,
        color: AppColors.purple,
      ),
    );
  }
}
