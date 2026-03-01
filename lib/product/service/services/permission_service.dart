import 'package:permission_handler/permission_handler.dart';

/// Service that centrally manages permission operations.
final class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  /// Checks the permission status.
  Future<PermissionStatus> check(Permission permission) {
    return permission.status;
  }

  /// Requests permission. Does not ask again if already granted.
  Future<PermissionStatus> request(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return status;
    return permission.request();
  }

  /// Returns whether the permission is granted as a bool.
  Future<bool> isGranted(Permission permission) {
    return permission.isGranted;
  }

  /// Redirects to settings if the user selected "don't ask again".
  Future<bool> openSettings() {
    return openAppSettings();
  }
}
