import 'api_client.dart';
import '../types/types.dart';

/// Auth API endpoints matching the NestJS backend.
class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<LoginResponse> login(String username, String password) async {
    final json = await _client.post('/auth/login', body: {
      'username': username,
      'password': password,
    });
    return LoginResponse.fromJson(json);
  }

  Future<LoginResponse> loginTemp(String username, String password) async {
    final json = await _client.post('/auth/login-temp', body: {
      'username': username,
      'password': password,
    });
    return LoginResponse.fromJson(json);
  }

  Future<LoginResponse> switchRole(String role) async {
    final json = await _client.post('/auth/switch-role', body: {'role': role});
    return LoginResponse.fromJson(json);
  }

  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? profilePictureUrl,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['displayName'] = displayName;
    if (profilePictureUrl != null) body['profilePictureUrl'] = profilePictureUrl;
    return _client.post('/auth/update-profile', body: body);
  }

  Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return _client.post('/auth/change-password', body: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<Map<String, dynamic>> uploadProfilePicture(String base64Image) async {
    return _client.post('/auth/upload-profile-picture', body: {
      'image': base64Image,
    });
  }

  Future<Map<String, dynamic>> submitAdmissionApplication({
    required String applicantName,
    required String parentName,
    required String parentPhone,
    String? parentEmail,
    String? csspsPlacementRef,
  }) async {
    return _client.post('/admissions/apply', body: {
      'applicantName': applicantName,
      'parentName': parentName,
      'parentPhone': parentPhone,
      if (parentEmail != null) 'parentEmail': parentEmail,
      if (csspsPlacementRef != null) 'csspsPlacementRef': csspsPlacementRef,
    });
  }
}

final authApi = AuthApi(apiClient);
