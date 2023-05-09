// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hello_world/data_container.dart';
import 'package:hello_world/Handler/screen_handler.dart';
import 'dart:developer';
import '../Exception/exceptions.dart' as exc;
import 'package:hello_world/admin_provider.dart';

class LoginHandler {
  static late TextEditingController userController;
  static late TextEditingController passController;
  static String? userError;
  static String? passError;
  static late Function(void Function()) setState;
  static late Function(void Function()) setStateful;
  static late BuildContext context;
  static bool loading = false;
  static late FocusNode userFocus;
  static late FocusNode passFocus;
  static bool errorVisible = false;
  //
  static void init() {
    userFocus = FocusNode();
    passFocus = FocusNode();
    userController = TextEditingController();
    passController = TextEditingController();
    userFocus.addListener(() {
      setState(() {});
    });

    passFocus.addListener(() {
      setState(() {});
    });
    LoginHandler.userController.addListener(() {
      if (LoginHandler.userController.text.isNotEmpty && LoginHandler.userError != null) {
        setState(() {
          LoginHandler.userError = null;
        });
      }
    });

    LoginHandler.passController.addListener(() {
      if (LoginHandler.passController.text.isNotEmpty && LoginHandler.passError != null) {
        setState(() {
          LoginHandler.passError = null;
        });
      }
    });
  }

  static bool validateUser() {
    if (userController.text.isEmpty) {
      userError = 'Please fill in Username input.';
      return false;
    }

    return true;
  }

  static bool validatePass() {
    if (passController.text.isEmpty) {
      passError = 'Please fill in Password input.';
      return false;
    }
    return true;
  }

  static Future<void> submitButton(Admin admin) async {
    if (LoginHandler.validateUser() & LoginHandler.validatePass()) {
      log('user input correct..');

      setStateful(() {
        loading = true;
      });
      try {
        log('checking credentials...');
        final String token = await admin.adminLogin();
        log('correct credentials, we welcome you admin:  @${LoginHandler.userController.text}');
        log('trying to sign in with recieved custom token..');
        await admin.signInWithCustomToken(token);

        //get last admin that logged in..
        await admin.setANDgetTIME();
        log('success logged in!!');
        setStateful(() {
          loading = false;
        });
        log('Done!');
        Screen.page = 1;
        Navigator.of(context).pushReplacementNamed(DataContainer.routeName);
      } on exc.InvalidArgumentException catch (_) {
        setState(() {
          log('Error, invalid username or password');
          errorVisible = true;
          loading = false;
        });
      }
    } else {
      setState(() {});
    }
  }
}
