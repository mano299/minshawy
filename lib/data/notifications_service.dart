import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Function(String action)? onAction;

  static Future<void> init() async {
    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId != null) {
          onAction?.call(response.actionId!);
        }
      },
    );
  }

  static Future<void> showProgress({
    required int progress,
    required String title,
  }) async {
    await notifications.show(
      id: 1,
      title: title,
      body: 'جاري التحميل $progress%',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Downloads',
          channelDescription: 'Quran Downloads',
          importance: Importance.high,
          priority: Priority.high,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          onlyAlertOnce: true,
          ongoing: progress < 100,
        ),
      ),
    );
  }

  static Future<void> complete(String title) async {
    await notifications.show(
      id: 1,
      title: title,
      body: 'تم التنزيل بنجاح',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Downloads',
          channelDescription: 'Quran Downloads',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // static Future<void> showPlayerNotification({
  //   required String surahName,
  //   required bool isPlaying,
  // }) async {
  //   await notifications.show(
  //     id: 999,
  //     title: surahName,
  //     body: isPlaying ? 'يتم التشغيل الآن' : 'متوقف مؤقتاً',
  //     notificationDetails: NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'player_channel',
  //         'Audio Player',
  //         channelDescription: 'Quran Player Controls',
  //         importance: Importance.low,
  //         priority: Priority.low,
  //         ongoing: isPlaying,
  //         autoCancel: false,
  //         actions: [
  //           AndroidNotificationAction('previous', 'السابق'),
  //           AndroidNotificationAction(
  //             isPlaying ? 'pause' : 'play',
  //             isPlaying ? 'إيقاف' : 'تشغيل',
  //           ),
  //           AndroidNotificationAction('next', 'التالي'),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
