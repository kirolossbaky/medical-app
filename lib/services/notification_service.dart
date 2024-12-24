import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._() {
    _init();
  }

  Future<void> _init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> scheduleMedicationReminder({
    required String medicationId,
    required String medicationName,
    required DateTime scheduledTime,
    required String dosage,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.zonedSchedule(
      medicationId.hashCode,
      'Medication Reminder',
      'Time to take $medicationName - $dosage',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelMedicationReminder(String medicationId) async {
    await _notifications.cancel(medicationId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'instant_notifications',
      'Instant Notifications',
      channelDescription: 'Notifications for immediate alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.hashCode,
      title,
      body,
      notificationDetails,
    );
  }
}
