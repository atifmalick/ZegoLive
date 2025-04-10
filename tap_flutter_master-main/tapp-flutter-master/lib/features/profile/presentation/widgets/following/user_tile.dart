import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/widgets/following/unfollow_user_option.dart';

class FollowingUserTile extends StatelessWidget {
  final TappUser _user;

  const FollowingUserTile(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          UnfollowUserOption(_user),
        ],
      ),
      child: ListTile(
        leading: CustomCircleAvatar(
          backgroundColor: AppColors.purple,
          url: _user.profilePicture?.url,
          fallbackTextSize: 16,
          fallbackText: _user.username!,
          radius: 20,
        ),
        title: Text(
          "${_user.username}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${_user.description}",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_left, color: Colors.black),
      ),
    );
  }
}
