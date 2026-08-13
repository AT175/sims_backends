import 'package:flutter/foundation.dart';

// ── Access Control Models (from RN accessControlStore.ts) ──

class PageAccessGrant {
  final String id, userId, username, displayName, dashboardKey, dashboardLabel, grantedBy, grantedAt;
  final dynamic allowedPages; // List<String> or 'all'
  const PageAccessGrant({
    required this.id, required this.userId, required this.username,
    required this.displayName, required this.dashboardKey, required this.dashboardLabel,
    required this.allowedPages, required this.grantedBy, required this.grantedAt,
  });
}

class AccessActivity {
  final String id, userId, username, displayName, dashboardKey, dashboardLabel, pageKey, pageLabel, action, timestamp;
  const AccessActivity({
    required this.id, required this.userId, required this.username, required this.displayName,
    required this.dashboardKey, required this.dashboardLabel, required this.pageKey,
    required this.pageLabel, required this.action, required this.timestamp,
  });
}

class AccessNotification {
  final String id, userId, displayName, dashboardKey, dashboardLabel, pageKey, pageLabel, message, timestamp, forRole;
  final bool read;
  const AccessNotification({
    required this.id, required this.userId, required this.displayName,
    required this.dashboardKey, required this.dashboardLabel, required this.pageKey,
    required this.pageLabel, required this.message, required this.timestamp,
    required this.read, required this.forRole,
  });
}

class AccessControlProvider extends ChangeNotifier {
  final List<PageAccessGrant> _grants = [
    PageAccessGrant(id: '1', userId: 'u1', username: 'jmensah', displayName: 'J. Mensah', dashboardKey: 'Teacher', dashboardLabel: 'Teacher', allowedPages: 'all', grantedBy: 'Headmaster', grantedAt: '2026-01-15T09:00:00Z'),
    PageAccessGrant(id: '2', userId: 'u2', username: 'gadjei', displayName: 'G. Adjei', dashboardKey: 'SubjectHOD', dashboardLabel: 'Subject HOD', allowedPages: 'all', grantedBy: 'Headmaster', grantedAt: '2026-01-15T09:05:00Z'),
    PageAccessGrant(id: '3', userId: 'u3', username: 'lfrimpong', displayName: 'L. Frimpong', dashboardKey: 'LibraryICT', dashboardLabel: 'Library & ICT', allowedPages: ['overview', 'books', 'circulation'], grantedBy: 'Headmaster', grantedAt: '2026-02-01T10:00:00Z'),
  ];

  final List<AccessActivity> _activities = [
    AccessActivity(id: '1', userId: 'u1', username: 'jmensah', displayName: 'J. Mensah', dashboardKey: 'Teacher', dashboardLabel: 'Teacher', pageKey: 'overview', pageLabel: 'Overview', action: 'viewed', timestamp: '2026-07-10T08:30:00Z'),
    AccessActivity(id: '2', userId: 'u2', username: 'gadjei', displayName: 'G. Adjei', dashboardKey: 'SubjectHOD', dashboardLabel: 'Subject HOD', pageKey: 'syllabus', pageLabel: 'Syllabus Coverage', action: 'viewed', timestamp: '2026-07-10T09:15:00Z'),
    AccessActivity(id: '3', userId: 'u3', username: 'lfrimpong', displayName: 'L. Frimpong', dashboardKey: 'LibraryICT', dashboardLabel: 'Library & ICT', pageKey: 'books', pageLabel: 'Book Catalogue', action: 'viewed', timestamp: '2026-07-09T14:20:00Z'),
  ];

  final List<AccessNotification> _notifications = [
    AccessNotification(id: '1', userId: 'u3', displayName: 'L. Frimpong', dashboardKey: 'LibraryICT', dashboardLabel: 'Library & ICT', pageKey: 'all', pageLabel: '3 page(s)', message: 'L. Frimpong has been assigned to Library & ICT (3 page(s))', timestamp: '2026-02-01T10:00:00Z', read: true, forRole: 'library_ict'),
  ];

  List<PageAccessGrant> get grants => List.unmodifiable(_grants);
  List<AccessActivity> get activities => List.unmodifiable(_activities);
  List<AccessNotification> get notifications => List.unmodifiable(_notifications);

  List<PageAccessGrant> getGrantsForUser(String userId) => _grants.where((g) => g.userId == userId).toList();
  List<PageAccessGrant> getAssigneesForDashboard(String dashboardKey) => _grants.where((g) => g.dashboardKey == dashboardKey).toList();
  List<AccessActivity> getActivitiesForDashboard(String dashboardKey) => _activities.where((a) => a.dashboardKey == dashboardKey).toList();
  List<AccessActivity> getActivitiesForUser(String userId) => _activities.where((a) => a.userId == userId).toList();
  List<AccessNotification> getNotificationsForRole(String role) => _notifications.where((n) => n.forRole == role).toList();
  List<String> getAssignedDashboardRoles(String userId) => _grants.where((g) => g.userId == userId).map((g) => g.dashboardKey).toList();

  int get totalGrants => _grants.length;
  int get totalActivities => _activities.length;
  int get unreadNotifications => _notifications.where((n) => !n.read).length;

  int _grantIdCounter = 100;

  void assignAccess({
    required String userId,
    required String username,
    required String displayName,
    required String dashboardKey,
    required String dashboardLabel,
    required dynamic allowedPages,
    required String grantedBy,
  }) {
    final existingIdx = _grants.indexWhere((g) => g.userId == userId && g.dashboardKey == dashboardKey);
    final id = existingIdx >= 0 ? _grants[existingIdx].id : (++_grantIdCounter).toString();
    final now = DateTime.now().toIso8601String();
    final grant = PageAccessGrant(
      id: id, userId: userId, username: username, displayName: displayName,
      dashboardKey: dashboardKey, dashboardLabel: dashboardLabel,
      allowedPages: allowedPages, grantedBy: grantedBy, grantedAt: now,
    );
    if (existingIdx >= 0) {
      _grants[existingIdx] = grant;
    } else {
      _grants.insert(0, grant);
    }
    notifyListeners();
  }

  void revokeAccess(String grantId) {
    _grants.removeWhere((g) => g.id == grantId);
    notifyListeners();
  }
}
