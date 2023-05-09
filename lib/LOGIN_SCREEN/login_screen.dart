import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hello_world/Handler/screen_handler.dart';
import 'dart:ui';
import 'package:window_manager/window_manager.dart';
import 'login_textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WindowListener, TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation opacityAnimation;
  late Animation blurAnimation;
  bool visiblity = false;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    opacityAnimation = Tween(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));
    blurAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      windowManager.addListener(this);

      animationController.addListener(() {
        setState(() {});
      });

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          visiblity = false;
        }
      });
    });

    super.initState();
  }

  @override
  void onWindowFocus() {
    if (Screen.page == 0) {
      visiblity = true;
      animationController.forward();
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    animationController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover))),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          )),
          const LoginFields(),
          Visibility(
            visible: visiblity,
            child: Positioned.fill(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurAnimation.value, sigmaY: blurAnimation.value),
              child: Opacity(
                opacity: opacityAnimation.value,
                child: Container(
                  color: Colors.black,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
