import 'package:flutter/material.dart';

enum NotificationType { course, offer, achievement, system }

/// A simple in-app notification (offline/demo). Holds Arabic + English text
/// and resolves the right one at display time.
class AppNotification {
  final NotificationType type;
  final String arTitle;
  final String enTitle;
  final String arBody;
  final String enBody;
  final String arTime;
  final String enTime;
  bool read;

  AppNotification({
    required this.type,
    required this.arTitle,
    required this.enTitle,
    required this.arBody,
    required this.enBody,
    this.arTime = 'الآن',
    this.enTime = 'now',
    this.read = false,
  });

  String title(bool isAr) => isAr ? arTitle : enTitle;
  String body(bool isAr) => isAr ? arBody : enBody;
  String time(bool isAr) => isAr ? arTime : enTime;

  IconData get icon {
    switch (type) {
      case NotificationType.course:
        return Icons.play_circle_outline_rounded;
      case NotificationType.offer:
        return Icons.local_offer_rounded;
      case NotificationType.achievement:
        return Icons.emoji_events_rounded;
      case NotificationType.system:
        return Icons.notifications_active_rounded;
    }
  }
}
