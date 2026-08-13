import 'package:flutter/foundation.dart';
import 'app_models.dart';

/// Notification store — in-app notification center.
class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(id: '1', title: 'New Admission Application', message: 'Selina Adjei has submitted a new application.', type: 'info', timestamp: DateTime.now().subtract(const Duration(hours: 2)), read: false),
    AppNotification(id: '2', title: 'Overdue Invoice', message: 'INV-2026/101 (Kofi Boateng) is overdue.', type: 'warning', timestamp: DateTime.now().subtract(const Duration(hours: 5)), read: false),
    AppNotification(id: '3', title: 'Exam Scheduled', message: 'Mid-Sem 1 Chemistry scheduled for July 16.', type: 'info', timestamp: DateTime.now().subtract(const Duration(days: 1)), read: true),
    AppNotification(id: '4', title: 'HOD Approval Needed', message: 'Mr. Adjei requests teacher assignment approval.', type: 'info', timestamp: DateTime.now().subtract(const Duration(days: 2)), read: false),
  ];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.read).length;

  void markRead(String id) {
    final n = _notifications.where((n) => n.id == id).firstOrNull;
    if (n != null) {
      _notifications[_notifications.indexOf(n)] = AppNotification(
        id: n.id, title: n.title, message: n.message, type: n.type,
        timestamp: n.timestamp, read: true,
      );
      notifyListeners();
    }
  }

  void markAllRead() {
    for (var i = 0; i < _notifications.length; i++) {
      final n = _notifications[i];
      if (!n.read) {
        _notifications[i] = AppNotification(
          id: n.id, title: n.title, message: n.message, type: n.type,
          timestamp: n.timestamp, read: true,
        );
      }
    }
    notifyListeners();
  }
}
