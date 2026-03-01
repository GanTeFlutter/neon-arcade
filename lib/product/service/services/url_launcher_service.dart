import 'dart:io';

import 'package:akillisletme/product/const/app_string.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service that centrally manages url_launcher operations.
final class UrlLauncherService {
  UrlLauncherService._();
  static final UrlLauncherService instance = UrlLauncherService._();

  /// Opens the given [url] in an in-app browser.
  Future<void> openInApp(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
  }

  /// Opens the given [url] in an external application (e.g. Instagram, Play Store).
  Future<void> openExternal(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  /// Opens App Store or Play Store depending on the platform.
  Future<void> openStore() async {
    final url = Platform.isIOS
        ? AppString.appStoreUrl
        : AppString.playStoreUrl;
    if (url.isEmpty) {
      debugPrint('UrlLauncherService.openStore -> Store URL not defined');
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  /// Opens the mail application.
  Future<void> sendEmail({
    required String to,
    String subject = '',
    String body = '',
  }) async {
    final params = <String, String>{
      if (subject.isNotEmpty) 'subject': subject,
      if (body.isNotEmpty) 'body': body,
    };

    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: params.isNotEmpty ? params : null,
    );

    debugPrint('UrlLauncherService.sendEmail -> $uri');
    await launchUrl(uri);
  }
}
