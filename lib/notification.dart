import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DebugViewNotification {
  DebugViewNotification({required this.onNotificationTapCallback});

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final notificationIcon = "@mipmap/ic_launcher";
  final Function onNotificationTapCallback;

  initializeNotificationsPlugin() async {
    print("initializeNotificationsPlugin");
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings(notificationIcon);
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectedNotification,
    );

    // En plus
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future showLocalNotification() async {
    print("showLocalNotification");
    const channelId = "DebugView";
    const channelName = "DebugView";
    const channelDescription = "DebugView";
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      enableVibration: false,
      playSound: false,
      largeIcon: DrawableResourceAndroidBitmap(notificationIcon),
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentSound: false,
      subtitle: "Debug View is running…",
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      "Debug View is running…",
      "Tap on this notification to open the debug view.",
      platformChannelSpecifics,
      payload: "",
    );
    return;
  }

  Future<void> _onSelectedNotification(String? payload) async {
    assert(payload != null, "payload can't be null");
    onNotificationTapCallback.call();
    return;
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    print("onDidReceiveLocalNotification");
  }
}
