import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const ProfileInfoTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    //   return ListTile(
    //     leading: Align(
    //       alignment: Alignment.bottomLeft,
    //       child: Icon(
    //         Icons.phone,
    //         color: AppColors.green,
    //         size: 28,
    //       ),
    //     ),
    //     title: Text(
    //       title,
    //       style: TextStyle(
    //         fontWeight: FontWeight.w600,
    //         fontSize: 14,
    //         color: AppColors.grey,
    //       ),
    //     ),
    //     subtitle: Text(
    //       subtitle,
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 16,
    //         color: AppColors.black,
    //       ),
    //     ),
    //   );
  }
}
