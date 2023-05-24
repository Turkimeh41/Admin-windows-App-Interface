// ignore_for_file: file_names

import 'dart:developer';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter/material.dart';

class WindowHandler {
  static Future<void> setWindow({required Size initSize, Size? maxSize, Size? minSize}) async {
    Window.initialize();
    Window.setEffect(effect: WindowEffect.transparent);
    WindowOptions windowOptions = WindowOptions(
      size: initSize,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Administrator',
    );
    if (maxSize != null && minSize != null) {
      windowManager.setMaximumSize(maxSize);
      windowManager.setMinimumSize(minSize);
    }

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAsFrameless();
      await windowManager.setHasShadow(false);
      await windowManager.show();
    });
  }

  static Future<void> setWindowSettings() async {
    log('setting up, window sizes for settings screen');
    await windowManager.setSize(const Size(1400, 1122));
    await windowManager.setResizable(false);
  }
}
