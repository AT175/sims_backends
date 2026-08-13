import 'role_id.dart';

/// Sync envelope — base fields for every synced record.
class SyncEnvelope {
  final String id;
  final String tenantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final DateTime? deletedAt;

  const SyncEnvelope({
    required this.id,
    required this.tenantId,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.deletedAt,
  });

  factory SyncEnvelope.fromJson(Map<String, dynamic> json) {
    return SyncEnvelope(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
    );
  }
}

/// Sync status for UI indicator.
enum SyncStatus { synced, syncing, offline, error }

/// Pending change in the sync queue.
class PendingChange {
  final String id;
  final String entityId;
  final String entityType;
  final String operation; // 'create' | 'update' | 'delete'
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final String deviceId;

  const PendingChange({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.operation,
    required this.payload,
    required this.timestamp,
    required this.deviceId,
  });
}

/// Authenticated user session.
class AuthUser {
  final String id;
  final String tenantId;
  final String schoolName;
  final String? schoolLogoUrl;
  final String? profilePictureUrl;
  final String username;
  final String displayName;
  final List<RoleId> roles;
  final RoleId activeRole;
  final String token;
  final String refreshToken;

  const AuthUser({
    required this.id,
    required this.tenantId,
    required this.schoolName,
    this.schoolLogoUrl,
    this.profilePictureUrl,
    required this.username,
    required this.displayName,
    required this.roles,
    required this.activeRole,
    required this.token,
    required this.refreshToken,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      schoolName: (json['schoolName'] as String?) ?? 'Unknown School',
      schoolLogoUrl: json['schoolLogoUrl'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((r) => RoleIdExt.fromString(r as String))
          .toList(),
      activeRole: RoleIdExt.fromString(json['activeRole'] as String),
      token: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  AuthUser copyWith({
    RoleId? activeRole,
    String? token,
    String? refreshToken,
    String? displayName,
    String? profilePictureUrl,
    List<RoleId>? roles,
  }) {
    return AuthUser(
      id: id,
      tenantId: tenantId,
      schoolName: schoolName,
      schoolLogoUrl: schoolLogoUrl,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      username: username,
      displayName: displayName ?? this.displayName,
      roles: roles ?? this.roles,
      activeRole: activeRole ?? this.activeRole,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

/// Login response from the API.
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final AuthUser user;
  final bool isTempLogin;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.isTempLogin = false,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: AuthUser.fromJson({
        ...userJson,
        'accessToken': json['accessToken'],
        'refreshToken': json['refreshToken'],
      }),
      isTempLogin: json['isTempLogin'] as bool? ?? false,
    );
  }
}

/// Term enum used across many entities.
enum Term { term1, term2, term3 }

extension TermExt on Term {
  String get label {
    switch (this) {
      case Term.term1: return 'Term 1';
      case Term.term2: return 'Term 2';
      case Term.term3: return 'Term 3';
    }
  }
}

/// SHS level.
enum SHSLevel { shs1, shs2, shs3 }

extension SHSLevelExt on SHSLevel {
  String get label {
    switch (this) {
      case SHSLevel.shs1: return 'SHS1';
      case SHSLevel.shs2: return 'SHS2';
      case SHSLevel.shs3: return 'SHS3';
    }
  }
}

/// Programme of study.
enum Programme {
  science,
  arts,
  business,
  technical,
  agriculture,
  visualArts,
  homeEconomics,
}

extension ProgrammeExt on Programme {
  String get label {
    switch (this) {
      case Programme.science: return 'Science';
      case Programme.arts: return 'Arts';
      case Programme.business: return 'Business';
      case Programme.technical: return 'Technical';
      case Programme.agriculture: return 'Agriculture';
      case Programme.visualArts: return 'Visual Arts';
      case Programme.homeEconomics: return 'Home Economics';
    }
  }
}
