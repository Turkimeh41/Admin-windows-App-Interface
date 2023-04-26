// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hello_world/Handler/screen_handler.dart';
import 'package:keyboard_event/keyboard_event.dart' as k;
import 'package:window_manager/window_manager.dart';

class Keyboard {
  static k.KeyboardEvent keyboardEvent = k.KeyboardEvent();

  static Future<void> switchFullScreenKey() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      log('Switching to fullscreen!');
      await windowManager.maximize();
    }
  }
}
