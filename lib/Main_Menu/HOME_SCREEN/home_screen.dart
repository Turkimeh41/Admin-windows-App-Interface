import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    controller = ScrollController();
    super.initState();
  }

  double _startPosition = 0.0;
  void _onPanStart(DragStartDetails details) {
    _startPosition = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final double offset = (_startPosition - details.globalPosition.dy) / 0.35;
    final double currentOffset = controller.offset + offset;

    // Get the minimum and maximum heights
    const double minHeight = 0.0;
    final double maxHeight = controller.position.maxScrollExtent;

    // Restrict dragging up if already at minimum height
    if (currentOffset < minHeight && controller.offset <= minHeight) {
      return;
    }

    // Restrict dragging down if already at maximum height
    if (currentOffset > maxHeight && controller.offset >= maxHeight) {
      return;
    }

    // Update the offset and start position
    controller.jumpTo(currentOffset.clamp(minHeight, maxHeight));
    _startPosition = details.globalPosition.dy;
  }

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(left: 220, top: 65),
      width: dw,
      height: dh,
      color: const Color.fromARGB(255, 20, 18, 26),
      child: GestureDetector(
        onPanStart: (details) {
          _onPanStart(details);
        },
        onPanUpdate: (details) {
          _onPanUpdate(details);
        },
        child: Transform.translate(
          offset: const Offset(-15, 0),
          child: VsScrollbar(
            isAlwaysShown: true,
            style: const VsScrollbarStyle(
              color: Colors.amber,
            ),
            controller: controller,
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: ListView(primary: false, controller: controller, children: [
                Container(
                  margin: const EdgeInsets.only(left: 80),
                  child: Text('Dashboard',
                      style: GoogleFonts.signika(
                        color: Colors.white,
                        fontSize: 56,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 160),
                  child: Text(
                    'Welcome Administrator!',
                    style: GoogleFonts.signika(color: Colors.purple[400]!, fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Divider(
                  indent: 5,
                  color: Color.fromARGB(255, 71, 71, 92),
                ),
                const SizedBox(
                  height: 125,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 110),
                  child: Text(
                    'Checkouts',
                    style: GoogleFonts.signika(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
