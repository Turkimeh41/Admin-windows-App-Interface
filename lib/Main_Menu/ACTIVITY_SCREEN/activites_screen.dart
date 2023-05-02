// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/ACTIVITY_SCREEN/activity_widget.dart';
import 'package:hello_world/activity_dialog.dart';
import 'package:hello_world/user_dialog.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Provider/activites_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:hello_world/Provider/activity_provider.dart';
import 'package:align_positioned/align_positioned.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late TextEditingController searchController;
  bool menu = false;
  int filter = 0;
  final GlobalKey key = GlobalKey();
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;
    final insActivites = Provider.of<Activites>(context);
    final filteredList = insActivites.searchActivity(filter: filter, search: searchController.text);
    return Column(children: [
      Stack(
        children: [
          Container(width: dw, height: 250, color: const Color.fromARGB(255, 20, 18, 26)),
          Positioned(
              top: 100,
              left: 50,
              child: Text(
                'Activites',
                style: GoogleFonts.signika(color: Colors.white, fontSize: 42),
              )),
          Positioned(
              right: 70,
              top: 200,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                      fixedSize: const MaterialStatePropertyAll(Size(200, 40)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  onPressed: () => ActivityDialog.addDialog(insActivites, context),
                  child: Text(
                    'Add an Activity',
                    style: GoogleFonts.signika(color: Colors.white, fontSize: 24),
                  )))
        ],
      ),
      const SizedBox(
          height: 1,
          child: Divider(
            thickness: 1.5,
          )),
      Expanded(child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return Container(
          color: const Color.fromARGB(255, 14, 13, 19),
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                width: dw,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(top: 48, left: 48, child: Text('Manage Activites', style: GoogleFonts.signika(color: Colors.white, fontSize: 26))),
                    Positioned(
                        top: 48,
                        child: SizedBox(
                          height: 45,
                          width: 400,
                          child: TextField(
                            textAlign: TextAlign.start,
                            controller: searchController,
                            style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    menu = !menu;
                                  });
                                },
                                icon: Image.asset(
                                  alignment: Alignment.centerLeft,
                                  width: 46,
                                  'assets/icons/filter.png',
                                  color: const Color.fromARGB(255, 115, 14, 124),
                                ),
                              ),
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, top: 7, bottom: 8, right: 12),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Color.fromARGB(255, 255, 255, 255), BlendMode.srcIn),
                                    child: Lottie.asset('assets/animations/icons8-search.json', animate: false),
                                  )),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 28, 24, 34),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 144, 147, 160),
                                fontSize: 15,
                              ),
                              hintText: 'Search by Name, Type',
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 0,
                        right: 20,
                        child: Text(
                          'All games and Activites has been created and published by SIX FLAGS corp\n i do not hold legal to all the games/activites specified',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 16),
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: menu ? 50 : 0,
                    width: 250,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        color: Color.fromARGB(255, 28, 24, 34)),
                    child: menu
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(color: filter == 0 ? Colors.transparent : const Color.fromARGB(255, 13, 11, 15), shape: BoxShape.circle),
                                    child: Radio(
                                        fillColor: filter != 0 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                        value: 0,
                                        groupValue: filter,
                                        onChanged: (val) {
                                          setState(() {
                                            filter = val!;
                                          });
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text('Name', style: GoogleFonts.signika(color: Colors.white, fontSize: 15)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(color: filter == 1 ? Colors.transparent : const Color.fromARGB(255, 13, 11, 15), shape: BoxShape.circle),
                                    child: Radio(
                                        fillColor: filter != 1 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                        value: 1,
                                        groupValue: filter,
                                        onChanged: (val) {
                                          setState(() {
                                            filter = val!;
                                          });
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text('Type', style: GoogleFonts.signika(color: Colors.white, fontSize: 15)),
                                ],
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
              GridView.builder(
                  padding: const EdgeInsets.only(top: 75, left: 75, right: 75),
                  physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                  itemCount: filteredList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 100, childAspectRatio: 2, mainAxisSpacing: 100),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: filteredList[index],
                      builder: (context, child) {
                        return const ActivityWidget();
                      },
                    );
                  }),
            ],
          ),
        );
      }))
    ]);
  }
}
