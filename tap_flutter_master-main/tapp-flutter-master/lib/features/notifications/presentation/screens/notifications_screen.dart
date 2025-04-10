import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/notifications/presentation/cubit/notifications/notifications_cubit.dart';
import 'package:tapp/features/notifications/presentation/widgets/notifications/notifications_header.dart';
import 'package:tapp/features/notifications/presentation/widgets/notifications/notifications_list.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notificationsCubit = getIt<NotificationsCubit>();

  @override
  void dispose() {
    _notificationsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadSuccess) {
          return SafeArea(
            bottom: false,
            child: BlocProvider<NotificationsCubit>(
              create: (context) =>
                  _notificationsCubit..getNotifications(state.tappUser.uid!),
              child: RefreshIndicator(
                onRefresh: () async {
                  await _notificationsCubit
                      .getNotifications(state.tappUser.uid!);
                },
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    NotificationsHeader(state.tappUser),
                    NotificationsList(state.tappUser.uid!),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
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
