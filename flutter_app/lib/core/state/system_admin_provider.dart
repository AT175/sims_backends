import 'package:flutter/foundation.dart';

class SystemUser {
  final String id, username, displayName, email, tenantId;
  final List<String> roles;
  final String status;
  final String? lastLogin;
  final String createdAt;
  final int failedAttempts;
  const SystemUser({required this.id, required this.username, required this.displayName, required this.email, required this.roles, required this.status, this.lastLogin, required this.createdAt, required this.tenantId, required this.failedAttempts});
}

class SystemLog {
  final String id, timestamp, level, source, message;
  final String? user;
  const SystemLog({required this.id, required this.timestamp, required this.level, required this.source, required this.message, this.user});
}

class TenantConfig {
  final String id, schoolName, schoolCode, region, district, address, phone, email, academicYear, term, subscriptionPlan, subscriptionExpiry;
  final String? logoUrl;
  final int maxStudents, maxStaff;
  final List<String> enabledModules;
  const TenantConfig({required this.id, required this.schoolName, required this.schoolCode, required this.region, required this.district, required this.address, required this.phone, required this.email, this.logoUrl, required this.academicYear, required this.term, required this.maxStudents, required this.maxStaff, required this.subscriptionPlan, required this.subscriptionExpiry, required this.enabledModules});
}

class BackupRecord {
  final String id, timestamp, type, size, status, performedBy;
  const BackupRecord({required this.id, required this.timestamp, required this.type, required this.size, required this.status, required this.performedBy});
}

class ModuleStatus {
  final String id, name, version, lastUpdated, health;
  final bool enabled;
  const ModuleStatus({required this.id, required this.name, required this.enabled, required this.version, required this.lastUpdated, required this.health});
}

class DatabaseHealth {
  final String status, connectionLatency, lastSync, storageUsed;
  final int activeConnections, totalRecords, pendingChanges, failedSyncs;
  const DatabaseHealth({required this.status, required this.connectionLatency, required this.activeConnections, required this.totalRecords, required this.lastSync, required this.pendingChanges, required this.failedSyncs, required this.storageUsed});
}

class SystemAdminProvider extends ChangeNotifier {
  final List<SystemUser> users = [
    SystemUser(id: '1', username: 'admin', displayName: 'System Administrator', email: 'admin@sims.edu', roles: ['system_admin'], status: 'Active', lastLogin: '2026-07-13 08:45', createdAt: '2026-01-01', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '2', username: 'headmaster', displayName: 'John Mensah', email: 'headmaster@sims.edu', roles: ['headmaster'], status: 'Active', lastLogin: '2026-07-13 07:30', createdAt: '2026-01-05', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '3', username: 'bursar', displayName: 'Sarah Owusu', email: 'bursar@sims.edu', roles: ['bursary'], status: 'Active', lastLogin: '2026-07-12 16:20', createdAt: '2026-01-05', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '4', username: 'registrar', displayName: 'Michael Boateng', email: 'registrar@sims.edu', roles: ['registry'], status: 'Active', lastLogin: '2026-07-13 09:00', createdAt: '2026-01-06', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '5', username: 'teacher1', displayName: 'Grace Adjei', email: 'gadjei@sims.edu', roles: ['teacher'], status: 'Active', lastLogin: '2026-07-12 15:10', createdAt: '2026-01-10', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '6', username: 'parent_addo', displayName: 'Mr. Addo', email: 'addo@email.com', roles: ['parent'], status: 'Active', lastLogin: '2026-07-10 14:00', createdAt: '2024-09-12', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '7', username: 'staff1', displayName: 'Kwame Asante', email: 'kasante@sims.edu', roles: ['staff'], status: 'Suspended', lastLogin: '2026-06-28 10:00', createdAt: '2026-02-01', tenantId: 'tenant_001', failedAttempts: 3),
    SystemUser(id: '8', username: 'security1', displayName: 'Daniel Tuffour', email: 'dtuffour@sims.edu', roles: ['security'], status: 'Active', lastLogin: '2026-07-13 06:00', createdAt: '2026-01-15', tenantId: 'tenant_001', failedAttempts: 0),
    SystemUser(id: '9', username: 'chaplain', displayName: 'Rev. Emmanuel Mensah', email: 'chaplain@sims.edu', roles: ['chaplain'], status: 'Active', lastLogin: '2026-07-13 07:00', createdAt: '2026-01-08', tenantId: 'tenant_001', failedAttempts: 0),
  ];

  final List<SystemLog> logs = [
    SystemLog(id: '1', timestamp: '2026-07-13 09:12:34', level: 'INFO', source: 'Auth', message: 'User admin logged in successfully', user: 'admin'),
    SystemLog(id: '2', timestamp: '2026-07-13 09:05:18', level: 'INFO', source: 'Sync', message: 'Full sync completed - 1,247 records synced', user: 'admin'),
    SystemLog(id: '3', timestamp: '2026-07-13 08:45:02', level: 'INFO', source: 'Auth', message: 'User registrar logged in successfully', user: 'registrar'),
    SystemLog(id: '4', timestamp: '2026-07-13 07:30:15', level: 'INFO', source: 'Auth', message: 'User headmaster logged in successfully', user: 'headmaster'),
    SystemLog(id: '5', timestamp: '2026-07-12 23:00:00', level: 'INFO', source: 'Backup', message: 'Automatic backup completed - 45.2 MB', user: 'system'),
    SystemLog(id: '6', timestamp: '2026-07-12 18:32:44', level: 'WARN', source: 'Auth', message: 'Failed login attempt for staff1 - 3rd attempt', user: 'staff1'),
    SystemLog(id: '7', timestamp: '2026-07-12 18:31:20', level: 'WARN', source: 'Auth', message: 'Failed login attempt for staff1 - 2nd attempt', user: 'staff1'),
    SystemLog(id: '8', timestamp: '2026-07-12 18:30:05', level: 'WARN', source: 'Auth', message: 'Failed login attempt for staff1 - 1st attempt', user: 'staff1'),
    SystemLog(id: '9', timestamp: '2026-07-12 16:20:33', level: 'INFO', source: 'Auth', message: 'User bursar logged in successfully', user: 'bursar'),
    SystemLog(id: '10', timestamp: '2026-07-12 14:15:00', level: 'ERROR', source: 'Sync', message: 'Sync failed for device_003 - connection timeout', user: 'system'),
    SystemLog(id: '11', timestamp: '2026-07-12 12:00:00', level: 'INFO', source: 'System', message: 'Module Academic updated to v2.1.0', user: 'admin'),
    SystemLog(id: '12', timestamp: '2026-07-11 23:00:00', level: 'INFO', source: 'Backup', message: 'Automatic backup completed - 44.8 MB', user: 'system'),
  ];

  final TenantConfig tenant = TenantConfig(
    id: 'tenant_001', schoolName: 'Ghana Senior High School', schoolCode: 'GSHS-001',
    region: 'Greater Accra', district: 'Accra Metropolitan', address: 'P.O. Box 1234, Accra',
    phone: '+233 30 255 0123', email: 'info@gshs.edu.gh', logoUrl: null,
    academicYear: '2026/2027', term: 'Term 1', maxStudents: 2000, maxStaff: 150,
    subscriptionPlan: 'Premium', subscriptionExpiry: '2027-12-31',
    enabledModules: ['Academic', 'Bursary', 'Registry', 'Admissions', 'Boarding', 'Health', 'Transport', 'Catering', 'Security', 'Library', 'Sports', 'PTA', 'Counselling'],
  );

  final List<BackupRecord> backups = [
    BackupRecord(id: '1', timestamp: '2026-07-12 23:00:00', type: 'Auto', size: '45.2 MB', status: 'Success', performedBy: 'system'),
    BackupRecord(id: '2', timestamp: '2026-07-11 23:00:00', type: 'Auto', size: '44.8 MB', status: 'Success', performedBy: 'system'),
    BackupRecord(id: '3', timestamp: '2026-07-10 23:00:00', type: 'Auto', size: '44.5 MB', status: 'Success', performedBy: 'system'),
    BackupRecord(id: '4', timestamp: '2026-07-09 14:00:00', type: 'Manual', size: '44.3 MB', status: 'Success', performedBy: 'admin'),
    BackupRecord(id: '5', timestamp: '2026-07-08 23:00:00', type: 'Auto', size: '44.1 MB', status: 'Success', performedBy: 'system'),
  ];

  final List<ModuleStatus> modules = [
    ModuleStatus(id: '1', name: 'Academic', enabled: true, version: '2.1.0', lastUpdated: '2026-07-12', health: 'Healthy'),
    ModuleStatus(id: '2', name: 'Bursary', enabled: true, version: '2.0.5', lastUpdated: '2026-06-28', health: 'Healthy'),
    ModuleStatus(id: '3', name: 'Registry', enabled: true, version: '2.1.0', lastUpdated: '2026-07-12', health: 'Healthy'),
    ModuleStatus(id: '4', name: 'Admissions', enabled: true, version: '1.5.0', lastUpdated: '2026-07-10', health: 'Healthy'),
    ModuleStatus(id: '5', name: 'Boarding', enabled: true, version: '1.8.0', lastUpdated: '2026-06-15', health: 'Healthy'),
    ModuleStatus(id: '6', name: 'Health', enabled: true, version: '1.3.0', lastUpdated: '2026-05-20', health: 'Healthy'),
    ModuleStatus(id: '7', name: 'Transport', enabled: true, version: '1.2.0', lastUpdated: '2026-05-10', health: 'Degraded'),
    ModuleStatus(id: '8', name: 'Catering', enabled: true, version: '1.4.0', lastUpdated: '2026-06-01', health: 'Healthy'),
    ModuleStatus(id: '9', name: 'Security', enabled: true, version: '1.6.0', lastUpdated: '2026-06-20', health: 'Healthy'),
    ModuleStatus(id: '10', name: 'Library & ICT', enabled: true, version: '1.1.0', lastUpdated: '2026-04-15', health: 'Healthy'),
    ModuleStatus(id: '11', name: 'Sports & Clubs', enabled: true, version: '1.0.5', lastUpdated: '2026-03-10', health: 'Healthy'),
    ModuleStatus(id: '12', name: 'Counselling', enabled: false, version: '0.9.0', lastUpdated: '2026-02-01', health: 'Offline'),
  ];

  final DatabaseHealth dbHealth = DatabaseHealth(
    status: 'Healthy', connectionLatency: '12ms', activeConnections: 8,
    totalRecords: 12453, lastSync: '2026-07-13 09:05:18', pendingChanges: 0,
    failedSyncs: 1, storageUsed: '2.4 GB',
  );

  int get activeUsers => users.where((u) => u.status == 'Active').length;
  int get suspendedUsers => users.where((u) => u.status == 'Suspended').length;
  int get enabledModules => modules.where((m) => m.enabled).length;
  int get errorLogs => logs.where((l) => l.level == 'ERROR').length;
  int get warnLogs => logs.where((l) => l.level == 'WARN').length;

  int _userIdCounter = 100;

  void addUser({required String username, required String displayName, required String email, required List<String> roles, required String status, String tenantId = 'tenant_001'}) {
    final id = (++_userIdCounter).toString();
    // Insert at top by creating a new list
    final newUsers = <SystemUser>[
      SystemUser(id: id, username: username, displayName: displayName, email: email, roles: roles, status: status, lastLogin: null, createdAt: DateTime.now().toIso8601String().substring(0, 10), tenantId: tenantId, failedAttempts: 0),
      ...users,
    ];
    users.clear();
    users.addAll(newUsers);
    notifyListeners();
  }

  void updateUserStatus(String id, String newStatus) {
    final idx = users.indexWhere((u) => u.id == id);
    if (idx >= 0) {
      final u = users[idx];
      users[idx] = SystemUser(id: u.id, username: u.username, displayName: u.displayName, email: u.email, roles: u.roles, status: newStatus, lastLogin: u.lastLogin, createdAt: u.createdAt, tenantId: u.tenantId, failedAttempts: u.failedAttempts);
      notifyListeners();
    }
  }

  void updateUserRoles(String id, List<String> newRoles) {
    final idx = users.indexWhere((u) => u.id == id);
    if (idx >= 0) {
      final u = users[idx];
      users[idx] = SystemUser(id: u.id, username: u.username, displayName: u.displayName, email: u.email, roles: newRoles, status: u.status, lastLogin: u.lastLogin, createdAt: u.createdAt, tenantId: u.tenantId, failedAttempts: u.failedAttempts);
      notifyListeners();
    }
  }

  void unlockUser(String id) {
    updateUserStatus(id, 'Active');
    final idx = users.indexWhere((u) => u.id == id);
    if (idx >= 0) {
      final u = users[idx];
      users[idx] = SystemUser(id: u.id, username: u.username, displayName: u.displayName, email: u.email, roles: u.roles, status: u.status, lastLogin: u.lastLogin, createdAt: u.createdAt, tenantId: u.tenantId, failedAttempts: 0);
      notifyListeners();
    }
  }

  void resetUserPassword(String id) {
    // In a real app, this would trigger a backend reset. Here we just log it.
    notifyListeners();
  }

  void deleteUser(String id) {
    users.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}
