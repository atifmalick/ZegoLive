import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/help_me/presentation/widgets/help_me/sending_alert_bottom_sheet.dart';

class AlertTypeButton extends StatelessWidget {
  final String asset;
  final String text;
  final String alertType;

  const AlertTypeButton({
    Key? key,
    required this.asset,
    required this.text,
    required this.alertType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.black,
          backgroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          elevation: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              height: 48,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            builder: (context) {
              return SendingAlertBottomSheet(alertType: alertType);
            },
          );
        },
      ),
    );
  }
}
