// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MANAGER_SCREEN/manager_screen.dart';
import '../TAB_SCREEN/scroll_handler.dart';
import 'USER_SCREEN/user_screen.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({super.key});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> with TickerProviderStateMixin {
  late ScrollHandler scrollHandler;
  late AnimationController animationController;
  TextEditingController searchController = TextEditingController();
  late FocusNode searchFocus;
  int index = 0;
  @override
  void initState() {
    scrollHandler = ScrollHandler();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    searchFocus = FocusNode();

    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        animationController.forward();
      } else if (!searchFocus.hasFocus) {
        animationController.reverse();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    searchController.dispose();
    searchFocus.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;
    //BACKGROUND Color with child stack
    return Container(
      color: const Color.fromARGB(255, 20, 18, 26),
      width: dw,
      height: dh,
      margin: const EdgeInsets.only(left: 240, top: 25),
      child: Stack(
        children: [
          //FIRST DIVIDER
          //INDIVIDUAL Dashboard Text
          Positioned(
              top: 75,
              left: 25,
              child: Text(
                'Individuals\'s Dashboard',
                style: GoogleFonts.catamaran(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
              )),

          //Navigation Users, Managers Buttons
          Positioned(
              top: 215,
              left: 70,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Text('Users', style: GoogleFonts.signika(color: index == 0 ? Colors.white : const Color.fromARGB(255, 133, 136, 150), fontSize: index == 0 ? 20 : 17.5)),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Text('Managers', style: GoogleFonts.signika(color: index == 1 ? Colors.white : const Color.fromARGB(255, 133, 136, 150), fontSize: index == 1 ? 20 : 17.5))),
                  )
                ],
              )),

          //SECOND DIVIDER
          Positioned(top: 240, width: dw, child: const Divider()),
          //Blue DIVIDER
          AnimatedPositioned(
            top: 240,
            left: index == 0 ? 65 : 179,
            duration: const Duration(milliseconds: 300),
            width: index == 0 ? 60 : 100,
            child: const Divider(
              thickness: 2.2,
              color: Color.fromARGB(255, 119, 19, 119),
            ),
          ),
          Container(
            width: dw,
            height: dh,
            margin: const EdgeInsets.only(top: 250, left: 2),
            child: index == 0 ? const UserScreen() : const ManagerScreen(),
          )
        ],
      ),
    );
  }
}
