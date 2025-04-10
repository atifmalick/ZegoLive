import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';
import 'package:tapp/features/notifications/presentation/widgets/notifications/report_notification_option.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/screens/streaming_page.dart';

class NotificationListTile extends StatelessWidget {
  final TappNotification _notification;

  const NotificationListTile(this._notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;
    return _buildNotificationTile(context, user);
  }

  Widget _buildNotificationTile(BuildContext context, TappUser user) {
    String title;
    String message;
    IconData icon;
    Color iconColor;
    Function()? buttonFunction;

    switch (_notification.notificationType) {
      case NotificationType.chat:
        title =
            '${_notification.title} ${AppLocalizations.of(context)!.i_send_you_a_message}';
        message = _notification.message;
        icon = Icons.chat_bubble_rounded;
        iconColor = AppColors.orange;
        buttonFunction = () {
          getIt<NavigationService>().navigateTo(Routes.checkExistingChatScreen,
              {'receiver': TappUser(username: _notification.title)});
        };
        break;
      case NotificationType.helpMe:
        title = _notification.title;
        message = AppLocalizations.of(context)!.someone_near_danger;
        icon = Icons.support;
        iconColor = AppColors.red;
        buttonFunction = () {
          getIt<NavigationService>().navigateTo(
            Routes.alertMapScreen,
            {
              'alertPosition': Position(
                latitude: _notification.latitude!,
                longitude: _notification.longitude!,
                accuracy: 0,
                speed: 0,
                altitude: 0,
                speedAccuracy: 0,
                heading: 0,
                timestamp: DateTime.now(),
                altitudeAccuracy: 0,
                headingAccuracy: 0,
              ),
              'alertType': _notification.alertType,
            },
          );
        };
        break;
      case NotificationType.newStream:
        title = _notification.title;
        message = AppLocalizations.of(context)!.someone_near_you_stream;
        icon = Icons.live_tv_outlined;
        iconColor = AppColors.red;
        buttonFunction = () {
          final liveStreamId = _notification.message;
          log(liveStreamId + "-live");
          if (Platform.isAndroid) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LivePage(
                executeFunction: false,
                liveStremId: user.username.toString() + "-liveStream",
                userId: user.uid.toString(),
                username: user.username.toString(),
                liveID: liveStreamId + "-live",
                isHost: false,
              ),
            ));
          } else {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => LivePage(
                executeFunction: false,
                liveStremId: user.username.toString() + "-liveStream",
                userId: user.uid.toString(),
                username: user.username.toString(),
                liveID: liveStreamId,
                isHost: false,
              ),
            ));
          }
        };
        break;
      default:
        title = AppLocalizations.of(context)!.unknow_notification;
        message = AppLocalizations.of(context)!.unknow_notification;
        icon = Icons.device_unknown;
        iconColor = AppColors.grey;
        buttonFunction = () {};
    }

    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          ReportNotificationOption(_notification),
        ],
      ),
      closeOnScroll: true,
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(
          title,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              DateHelper.shortDateWithTime(_notification.date),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_left, color: Colors.black),
        onTap: buttonFunction,
      ),
    );
  }
}
