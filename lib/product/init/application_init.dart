import 'package:akillisletme/product/service/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@immutable
final class ApplicationInit {
  const ApplicationInit();

  Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    // TODO(akillisletme): Firebase entegrasyonu
    await setupLocator();
  }
}
