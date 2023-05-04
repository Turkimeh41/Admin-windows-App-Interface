// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'package:keyboard_event/keyboard_event.dart' as k;
import 'package:window_manager/window_manager.dart';
import 'package:chalkdart/chalk.dart';

class Keyboard {
  static String idToken = '';
  static String refreshToken = '';
  static k.KeyboardEvent keyboardEvent = k.KeyboardEvent();

  static void initilize() {
    keyboardEvent.startListening((keyEvent) async {
      if (keyEvent.isKeyDown && await windowManager.isFocused()) {
        final keyPressed = keyEvent.vkCode;

        switch (keyPressed) {
//F1 to show window width and height sizes
          case 112:
            final size = await windowManager.getSize();
            log(chalk.green.bold("Width of the window: ${size.width}"));
            log(chalk.green.bold("Height of the window: ${size.height}"));
            log(chalk.green.bold("=============================="));
            break;
          // F2 to show admin details
          case 113:
            log(chalk.green.bold("Admin idToken: $idToken"));
            log(chalk.green.bold("refresh token: $refreshToken"));
            log(chalk.green.bold("=============================="));
            break;
        }
      }
    });
  }
}
