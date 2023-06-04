import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/HOME_SCREEN/activites_monitor_users.dart';
import 'package:hello_world/Main_Menu/HOME_SCREEN/pie_chart_userToAnony.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController(keepScrollOffset: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(left: 240, top: 65),
      width: dw,
      height: dh,
      color: const Color.fromARGB(255, 20, 18, 26),
      child: VsScrollbar(
        isAlwaysShown: true,
        style: const VsScrollbarStyle(
          color: Color.fromARGB(255, 240, 201, 84),
        ),
        controller: controller,
        child: ListView(
          padding: const EdgeInsets.all(36),
          controller: controller,
          children: [
            Text('Dashboard',
                style: GoogleFonts.signika(
                  color: Colors.white,
                  fontSize: 56,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                'Welcome Administrator!',
                style: GoogleFonts.signika(color: Colors.purple[400]!, fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            Text(
              'Anonymous To Users Pie Chart',
              style: GoogleFonts.signika(color: Colors.white, fontSize: 26),
            ),
            const SizedBox(height: 40),
            const PieChartUserAnony(),
            const SizedBox(height: 200),
            const ActivitesMonitorUsers()
          ],
        ),
      ),
    );
  }
}
