import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/widgets/trust_list/delete_user_option.dart';

class UserTile extends StatelessWidget {
  final TappUser _user;

  const UserTile(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          DeleteUserOption(_user),
          // SendMessageOption(_user),
        ],
      ),
      child: ListTile(
        leading: CustomCircleAvatar(
          backgroundColor: AppColors.purple,
          url: _user.profilePicture?.url,
          fallbackTextSize: 16,
          fallbackText: _user.username??'User',
          radius: 20,
        ),
        title: Text(
          _user.name!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _user.username??'Username',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_left, color: Colors.black),
      ),
    );
  }
}
