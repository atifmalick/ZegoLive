import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/notifications/data/models/firebase_notification_model.dart';
import 'package:tapp/features/notifications/domain/entities/firebase_notification.dart';

part 'firebase_notifications_state.dart';

@lazySingleton
class FirebaseNotificationsCubit extends Cubit<FirebaseNotificationsState> {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late AndroidNotificationChannel _androidChannel;
  late AndroidNotificationDetails _androidNotificationDetails;

  FirebaseNotificationsCubit(this._localNotificationsPlugin)
      : super(FirebaseNotificationsInitial());

  Future<String?> get token => FirebaseMessaging.instance.getToken();

  // Initialize FlutterLocalNotificationsPlugin
  // and set function to handle notification's tap on foreground
  Future<void> configureFln() async {
    const androidSettings = AndroidInitializationSettings('app_icon');

    const iosSettings = DarwinInitializationSettings();
    const globalSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _androidChannel = const AndroidNotificationChannel(
      'tapp_channel',
      'Tapp Notifications',
      importance: Importance.max,
    );

    _androidNotificationDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      importance: _androidChannel.importance,
      priority: Priority.max,
      showWhen: false,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await _localNotificationsPlugin.initialize(
      globalSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        final notification =
            FirebaseNotificationModel.fromJson(jsonDecode(payload ?? ''));
        _handleNotifications(notification);
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        final notification =
            FirebaseNotificationModel.fromJson(jsonDecode(payload ?? ''));
        _handleNotifications(notification);
      },
    );
  }

  // Configure FirebaseMessaging to receive foreground and background notifications
  // set functions to handle both cases
  Future<void> configureFcm() async {
    // When notification is received in foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        final notification = FirebaseNotificationModel.fromRemoteMessage(
          message,
        );
        log(message.toString(), name: "Notification Received Foreground");
        await _showNotificationOnForeground(notification);
      },
    );

    // When notification is received in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = FirebaseNotificationModel.fromRemoteMessage(message);
      _handleNotifications(notification);
    });
  }

  // Function to show notification on foreground (when app is in use)
  Future<void> _showNotificationOnForeground(
    FirebaseNotificationModel notification,
  ) async {
    final globalDetails = NotificationDetails(
      android: _androidNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      globalDetails,
      payload: jsonEncode(notification.toJson()),
    );
  }

  // Function for notifications received in background but on terminated state (app closed)
  Future<void> getNotificationsFromTerminatedState() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      final notification = FirebaseNotificationModel.fromRemoteMessage(message);
      _handleNotifications(notification);
    }
  }

  // Handler to determine the type of the notification received
  void _handleNotifications(FirebaseNotificationModel notification) {
    switch (notification.notificationType) {
      case NotificationType.chat:
        emit(FirebaseChatNotificationReceived(notification));
        break;
      case NotificationType.helpMe:
        emit(FirebaseHelpMeNotificationReceived(notification));
        break;
      case NotificationType.newStream:
        _navigateToStream(notification);
        emit(FirebaseNewStreamNotificationReceived(notification));
        break;
      default:
        break;
    }

    // To make bloc listener listen even the previous state is same to next state
    // this state will be intermediate, for example:
    //  -> FirebaseChatNotificationReceived
    //  -> FirebaseNotificationsInitial
    //  -> FirebaseChatNotificationReceived
    emit(FirebaseNotificationsInitial());
  }

  void _navigateToStream(FirebaseNotificationModel notification) {
    log(notification.toString(), name: "_navigate");
  }

  Future<void> deleteToken() async =>
      await FirebaseMessaging.instance.deleteToken();
}
