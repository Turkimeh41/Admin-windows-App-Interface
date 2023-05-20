// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Handler/Window_handler.dart';
import 'package:hello_world/Dialogs/user_dialog.dart';
import 'package:hello_world/Provider/activites_provider.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'package:hello_world/SETTINGS/settings_screen.dart';
import '../ACTIVITY_SCREEN/activites_screen.dart';
import '../HOME_SCREEN/home_screen.dart';
import '../INDIVIDUAL_SCREEN/individuals_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:hello_world/admin_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Custom/vertical_divider.dart' as vert;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with /* WindowListener, */ TickerProviderStateMixin {
  int state = 0;
  late AnimationController controller;
  ValueNotifier counter = ValueNotifier<int>(0);

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(minutes: 1), (_) {
        counter.value++;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> _refresh() async {
    await Provider.of<Activites>(context, listen: false).fetchActivites();
    await Provider.of<AnonymousUsers>(context, listen: false).fetchAnonymousUsers();
    await Provider.of<Managers>(context, listen: false).fetchManagers();
    await Provider.of<Users>(context, listen: false).fetchUsers();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;
    final admin = Provider.of<Admin>(context, listen: false);

    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 10),
      width: dw,
      height: dh,
      child: loading == false
          ? Stack(children: [
              //NAVIGATION TO OTHER SCREENS
              if (state == 0) const HomeScreen() else if (state == 1) const IndividualScreen() else const Padding(padding: EdgeInsets.only(top: 25.0, left: 240), child: ActivityScreen()),
              Positioned(
                right: 0,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 23, 23, 33),
                        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(3, -1)), BoxShadow(color: Color.fromARGB(255, 18, 18, 20), blurRadius: 10, offset: Offset(3, -1))]),
                    width: dw,
                    height: 65),
              ),
              Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 23, 23, 33),
                      boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0.5, 0)), BoxShadow(color: Color.fromARGB(255, 18, 18, 20), blurRadius: 10, offset: Offset(1, 0))]),
                  height: dh,
                  width: 240),

              Positioned(
                  top: 15,
                  left: 250,
                  child: ValueListenableBuilder(
                    valueListenable: counter,
                    builder: (context, value, child) {
                      return Container(
                        margin: const EdgeInsets.only(top: 13, left: 20),
                        child: Text(
                          'Last admin login: ${admin.formatDate()}',
                          style: GoogleFonts.signika(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  )),
              //Container to conceal leftover shades
              Positioned(
                  top: 15,
                  left: 225,
                  height: 50,
                  width: 30,
                  child: Container(
                    color: const Color.fromARGB(255, 23, 23, 33),
                  )),
              //TWO ICONS, BELL AND MESSAGES
              Positioned(
                  top: 20,
                  right: 15,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              await _refresh();
                              setState(() {
                                loading = false;
                              });
                            },
                            icon: const Icon(size: 32, Icons.refresh, color: Colors.grey)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.bell, color: Colors.grey)),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.message, color: Colors.grey))
                    ],
                  )),

              //Lottie
              Positioned(top: 20, left: 20, child: Lottie.asset('assets/animations/admin.json', width: 192, controller: controller)),

              //hello admin
              Positioned(top: 200, left: 40, child: Text('Hello, Admin !', style: GoogleFonts.signika(color: Colors.white, fontSize: 24))),

              //container for state 0
              Positioned(
                  top: 290,
                  left: 10,
                  child: state == 0
                      ? Container(
                          width: 210,
                          height: 37.5,
                          padding: const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 14, 13, 22)),
                        )
                      : const SizedBox()),
              //button for state 0
              Positioned(
                top: 290,
                left: 20,
                child: Row(
                  children: [
                    Icon(
                      state == 0 ? Icons.home : Icons.home_outlined,
                      color: state == 0 ? Colors.white : const Color.fromARGB(255, 174, 173, 180),
                      size: 36,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Home',
                      style: GoogleFonts.signika(color: state == 0 ? Colors.white : const Color.fromARGB(255, 174, 173, 180), fontSize: 17),
                    )
                  ],
                ),
              ),
              //Mouse click state 0
              Positioned(
                  top: 290,
                  left: 10,
                  width: 210,
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
              const Positioned(
                top: 330,
                width: 240,
                child: Divider(),
              ),

              //state 1 container
              Positioned(
                  top: 360,
                  left: 10,
                  child: state == 1
                      ? Container(
                          width: 210,
                          height: 37.5,
                          padding: const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 14, 13, 22)),
                        )
                      : const SizedBox()),

              //state 1 button
              Positioned(
                top: 360,
                left: 20,
                child: Row(
                  children: [
                    Icon(
                      state == 1 ? Icons.supervised_user_circle_sharp : Icons.supervised_user_circle_outlined,
                      color: state == 1 ? Colors.white : const Color.fromARGB(255, 174, 173, 180),
                      size: 36,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Individuals',
                      style: GoogleFonts.signika(color: state == 1 ? Colors.white : const Color.fromARGB(255, 174, 173, 180), fontSize: 17),
                    )
                  ],
                ),
              ),
              //mouse click state 1
              Positioned(
                  top: 360,
                  left: 10,
                  width: 210,
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
                  top: 410,
                  left: 10,
                  child: state == 2
                      ? Container(
                          width: 210,
                          height: 37.5,
                          padding: const EdgeInsets.only(left: 8, top: 15, bottom: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 14, 13, 22)),
                        )
                      : const SizedBox()),
              Positioned(
                  top: 410,
                  left: 20,
                  child: Row(
                    children: [
                      Icon(
                        state == 2 ? Icons.gamepad : Icons.gamepad_outlined,
                        color: state == 2 ? Colors.white : const Color.fromARGB(255, 174, 173, 180),
                        size: 36,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Activites',
                        style: GoogleFonts.signika(color: state == 2 ? Colors.white : const Color.fromARGB(255, 174, 173, 180), fontSize: 17),
                      )
                    ],
                  )),
              Positioned(
                  top: 410,
                  left: 10,
                  width: 210,
                  height: 37.5,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          state = 2;
                        });
                      },
                    ),
                  )),

              Positioned(
                  bottom: 30,
                  left: 40,
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await WindowHandler.setWindowSettings();
                            Navigator.of(context).pushNamed(SettingScreen.routename);
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 24,
                            color: Color.fromARGB(255, 174, 173, 180),
                          )),
                      const vert.VerticalDivider(
                        height: 25,
                        thickness: 2,
                      ),
                      IconButton(
                          onPressed: () => UserDialog.logoutDialog(context, admin),
                          icon: const Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 174, 173, 180),
                            size: 24,
                          ))
                    ],
                  )),
            ])
          : Container(
              color: const Color.fromARGB(255, 20, 18, 26),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Color.fromARGB(255, 87, 14, 26),
                ),
              ),
            ),
    ));
  }
}
