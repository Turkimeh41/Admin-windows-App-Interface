// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hello_world/SETTINGS/api_screen.dart';
import 'package:hello_world/SETTINGS/general.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_event/keyboard_event.dart' as k;
import 'package:window_manager/window_manager.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static const routename = '/settings';
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int state = 0;
  static k.KeyboardEvent keyboardEvent = k.KeyboardEvent();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      keyboardEvent.startListening((keyEvent) async {
        if (keyEvent.isKeyDown && await windowManager.isFocused()) {
          if (keyEvent.vkCode == 27) {
            await windowManager.setResizable(true);
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardEvent.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dh = MediaQuery.of(context).size.height;
    final dw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        //Navigate to
        Container(margin: const EdgeInsets.only(left: 360, top: 65), child: state == 0 ? const GeneralScreen() : const ApiScreen()),
        Positioned(
          right: 0,
          child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 23, 23, 33),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(3, -1)), BoxShadow(color: Color.fromARGB(255, 18, 18, 20), blurRadius: 10, offset: Offset(3, -1))]),
              width: dw,
              height: 65),
        ),
        Positioned(
            top: 0,
            left: 0,
            width: 360,
            height: dh,
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 23, 23, 33),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0.5, 0)), BoxShadow(color: Color.fromARGB(255, 18, 18, 20), blurRadius: 10, offset: Offset(1, 0))]))),
        //conceal leftover
        Positioned(
            top: 15,
            left: 360,
            height: 50,
            width: 30,
            child: Container(
              color: const Color.fromARGB(255, 23, 23, 33),
            )),
        //container for state 0
        Positioned(
            top: 290,
            left: 140,
            child: state == 0
                ? Container(
                    width: 185,
                    height: 37.5,
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 14, 13, 22)),
                  )
                : const SizedBox()),
        //button for state 0
        Positioned(
          top: 296,
          left: 150,
          child: Text(
            'General',
            style: GoogleFonts.signika(color: state == 0 ? Colors.white : const Color.fromARGB(255, 174, 173, 180), fontSize: 18.5),
          ),
        ),
        //Mouse click state 0
        Positioned(
            top: 290,
            left: 140,
            width: 185,
            height: 37.5,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    state = 0;
                  });
                },
              ),
            )),
        //container for state 1
        Positioned(
            top: 360,
            left: 140,
            child: state == 1
                ? Container(
                    width: 185,
                    height: 37.5,
                    padding: const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 14, 13, 22)),
                  )
                : const SizedBox()),
        //button for state 1
        Positioned(
          top: 367,
          left: 150,
          child: Text(
            'API',
            style: GoogleFonts.signika(color: state == 1 ? Colors.white : const Color.fromARGB(255, 174, 173, 180), fontSize: 18.5),
          ),
        ),
        //Mouse click state 1
        Positioned(
            top: 360,
            left: 140,
            width: 185,
            height: 37.5,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    state = 1;
                  });
                },
              ),
            )),
        Positioned(
            top: 130,
            right: 100,
            child: Column(
              children: [
                IconButton(
                    color: Colors.white,
                    iconSize: 52,
                    onPressed: () async {
                      await windowManager.setResizable(true);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel_outlined)),
                Text(
                  'ESC',
                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                )
              ],
            ))
      ]),
    );
  }
}
