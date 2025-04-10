import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tapp/core/themes/app_colors.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.delete_your_account,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              AppLocalizations.of(context)!.you_sure_delete_account,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.action_cannot_undone,
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 160,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white),
                  icon: Icon(Icons.delete, size: 20, color: AppColors.purple),
                  label: Text(
                    AppLocalizations.of(context)!.delete_your_account,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed("/confirmDeleteAccountScreen"),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 160,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple),
                  icon: Icon(Icons.cancel, size: 20, color: AppColors.white),
                  label: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
