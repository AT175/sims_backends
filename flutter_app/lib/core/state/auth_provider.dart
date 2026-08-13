import 'package:flutter/foundation.dart';
import '../api/api.dart';
import '../types/types.dart';

/// Auth state manager — mirrors the Zustand authStore from the React Native app.
class AuthProvider extends ChangeNotifier {
  AuthUser? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  bool _isTempLogin = false;

  AuthUser? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTempLogin => _isTempLogin;

  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await authApi.login(username, password);
      _user = response.user;
      _isAuthenticated = true;
      _isTempLogin = false;
      apiClient.setAuth(response.user.token, response.user.tenantId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Login failed: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> loginTemp(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await authApi.loginTemp(username, password);
      _user = response.user;
      _isAuthenticated = true;
      _isTempLogin = true;
      apiClient.setAuth(response.user.token, response.user.tenantId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Login failed: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  void logout() {
    apiClient.setAuth(null, null);
    _user = null;
    _isAuthenticated = false;
    _isTempLogin = false;
    _error = null;
    notifyListeners();
  }

  Future<void> switchRole(RoleId roleId) async {
    if (_user == null) return;

    // Demo mode: switch locally without API
    if (_user!.token == 'demo-token') {
      _user = _user!.copyWith(activeRole: roleId);
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final response = await authApi.switchRole(roleId.value);
      _user = _user!.copyWith(
        activeRole: response.user.activeRole,
        token: response.user.token,
        refreshToken: response.user.refreshToken,
        profilePictureUrl: response.user.profilePictureUrl,
      );
      apiClient.setAuth(_user!.token, _user!.tenantId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Role switch failed: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    String? displayName,
    String? profilePictureUrl,
  }) async {
    if (_user == null) return;

    // Demo mode: update locally without API
    if (_user!.token == 'demo-token') {
      _user = _user!.copyWith(
        displayName: displayName ?? _user!.displayName,
        profilePictureUrl: profilePictureUrl ?? _user!.profilePictureUrl,
      );
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await authApi.updateProfile(
        displayName: displayName,
        profilePictureUrl: profilePictureUrl,
      );
      _user = _user!.copyWith(
        displayName: result['displayName'] as String? ?? displayName,
        profilePictureUrl: result['profilePictureUrl'] as String? ?? profilePictureUrl,
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Profile update failed: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    // Demo mode: no-op success
    if (_user != null && _user!.token == 'demo-token') {
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      await authApi.changePassword(currentPassword, newPassword);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Password change failed: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
