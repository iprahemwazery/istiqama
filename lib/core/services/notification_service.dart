import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('notification_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'prayer_times_channel',
          'مواقيت الصلاة',
          description: 'إشعارات مواقيت الصلاة',
          importance: Importance.high,
          playSound: true,
        ),
      );
    }

    await _requestPermission();

    _initialized = true;
  }

  Future<void> _requestPermission() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> schedulePrayerNotifications(PrayerTimes prayerTimes) async {
    await _plugin.cancelAll();

    final tzLocation = tz.local;

    final prayers = <String, DateTime>{
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    final now = tz.TZDateTime.now(tzLocation);

    int id = 0;
    for (final entry in prayers.entries) {
      final tzScheduledAt = tz.TZDateTime.from(entry.value, tzLocation);

      if (tzScheduledAt.isAfter(now)) {
        await _plugin.zonedSchedule(
          id,
          'حان الآن موعد الأذان',
          'حان الآن وقت صلاة ${entry.key} حسب توقيتك المحلي',
          tzScheduledAt,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_times_channel',
              'مواقيت الصلاة',
              channelDescription: 'إشعارات مواقيت الصلاة',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
      id++;
    }

    await schedulePrayerAlarms(prayerTimes);
  }

  Future<void> schedulePrayerAlarms(PrayerTimes prayerTimes) async {
    final prayers = <String, DateTime>{
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    final prayerTimesMillis = prayers.values
        .map((dt) => dt.millisecondsSinceEpoch)
        .toList();
    final prayerNames = prayers.keys.toList();

    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('schedulePrayerAlarms', {
      'prayerTimes': prayerTimesMillis,
      'prayerNames': prayerNames,
    });
  }

  Future<void> showTestNotification() async {
    if (!_initialized) {
      debugPrint('showTestNotification: not initialized, re-initializing...');
      await initialize();
    }

    await _requestPermission();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times_channel',
        'مواقيت الصلاة',
        channelDescription: 'إشعارات مواقيت الصلاة',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableLights: true,
        enableVibration: true,
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _plugin.show(
        0,
        '🛠️ إشعار تجريبي ناجح',
        'تطبيقك جاهز الآن لجدولة مواقيت الصلاة!',
        details,
      );
      debugPrint('showTestNotification: immediate notification sent');
    } catch (e) {
      debugPrint('showTestNotification immediate error: $e');
    }

    final tzLocation = tz.local;
    final tzScheduledAt = tz.TZDateTime.now(tzLocation).add(
      const Duration(seconds: 10),
    );

    try {
      await _plugin.zonedSchedule(
        1,
        '🛠️ إشعار مجدول',
        'الإشعار المجدول - الـ scheduling شغال',
        tzScheduledAt,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('showTestNotification: scheduled notification set');
    } catch (e) {
      debugPrint('showTestNotification scheduled error: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;
    final result = await androidPlugin.areNotificationsEnabled();
    return result ?? false;
  }

  Future<void> openNotificationSettings() async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('openNotificationSettings');
  }

  Future<void> openAppSettings() async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('openAppSettings');
  }

  Future<void> openBatteryOptimizationSettings() async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('openBatteryOptimizationSettings');
  }

  Future<void> startForegroundService() async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('startForegroundService');
  }

  Future<void> stopForegroundService() async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('stopForegroundService');
  }

  Future<void> testRealBackgroundNotification({
    int delaySeconds = 15,
    String? title,
    String? body,
  }) async {
    const channel = MethodChannel('istiqama/notifications');
    await channel.invokeMethod('testBackgroundNotification', {
      'delay': delaySeconds * 1000,
      'title': title ?? '🕌 اختبار الإشعار الخلفي',
      'body': body ?? 'الإشعار شغال حتى لو التطبيق مقفول!',
    });
  }
}
