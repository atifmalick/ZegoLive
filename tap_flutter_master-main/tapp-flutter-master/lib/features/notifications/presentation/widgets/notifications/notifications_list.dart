import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/notifications/presentation/cubit/notifications/notifications_cubit.dart';
import 'package:tapp/features/notifications/presentation/widgets/notifications/empty_notifications.dart';
import 'package:tapp/features/notifications/presentation/widgets/notifications/notification_list_tile.dart';

class NotificationsList extends StatelessWidget {
  final String uid;

  const NotificationsList(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsInitial ||
            state is NotificationsLoadInProgress) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        } else if (state is NotificationsLoadSuccess) {
          return state.notifications.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, i) => NotificationListTile(
                    state.notifications[i],
                  ),
                )
              : const EmptyNotifications();
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        }
      },
    );
  }
}
