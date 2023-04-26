import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  bool reveal = false;
  @override
  Widget build(BuildContext context) {
    final dh = MediaQuery.of(context).size.height;
    final dw = MediaQuery.of(context).size.width;
    return Container(
      width: dw,
      height: dh,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 14, 13, 19),
      ),
      child: VsScrollbar(
        controller: scrollController,
        style: const VsScrollbarStyle(color: Colors.white),
        child: ListView(
          controller: scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110, left: 120),
              child: Text(
                'My Account',
                style: GoogleFonts.signika(color: Colors.white, fontSize: 42),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 15),
              margin: const EdgeInsets.only(top: 60, left: 80, right: 570),
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 20, 18, 26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EMAIL:',
                    style: GoogleFonts.signika(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        reveal ? 'trky-almhini@hotmail.com' : '***********@hotmail.com',
                        style: GoogleFonts.signika(color: Colors.white, fontSize: 20),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              reveal = !reveal;
                            });
                          },
                          child: Text(
                            reveal ? 'Unreveal' : 'Reveal',
                            style: GoogleFonts.signika(color: const Color.fromARGB(255, 119, 19, 119), fontSize: 22),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
