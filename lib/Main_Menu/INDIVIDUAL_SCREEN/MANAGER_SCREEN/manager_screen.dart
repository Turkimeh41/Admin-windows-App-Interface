import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Custom/desktop_scrollbehavior.dart';
import 'package:hello_world/Dialogs/manager_dialog.dart';
import 'package:hello_world/Main_Menu/INDIVIDUAL_SCREEN/MANAGER_SCREEN/manager_widget.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  late TextEditingController searchController;
  late FocusNode searchFocus;
  late PageController pageController;
  int currentPage = 0;
  int filter = 0;
  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.4);
    searchFocus = FocusNode();
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dh = MediaQuery.of(context).size.height;
    final dw = MediaQuery.of(context).size.width;
    final insManagers = Provider.of<Managers>(context);
    final filteredManagers = insManagers.filteredManager(searchController.text, filter);

    return Container(
      height: dh,
      width: dw,
      color: const Color.fromARGB(255, 14, 13, 19),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 36.0, left: 16),
            child: UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(24),
                height: 230,
                width: 640,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 20, 18, 26), borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 40),
                      child: Text(
                        'Managers',
                        style: GoogleFonts.signika(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, top: 8.0),
                      child: Text(
                        'Managers can be added here.',
                        style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18.5),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(240, 50)), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124))),
                            onPressed: () => ManagerDialog.addDialog(context, insManagers),
                            child: Text(
                              'Add a new manager',
                              style: GoogleFonts.signika(fontSize: 24),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 36),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: UnconstrainedBox(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 500,
                  height: 60,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    focusNode: searchFocus,
                    textAlign: TextAlign.start,
                    controller: searchController,
                    style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 7, bottom: 8, right: 12),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(Color.fromARGB(255, 255, 255, 255), BlendMode.srcIn),
                            child: Lottie.asset('assets/animations/icons8-search.json', animate: false),
                          )),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 28, 25, 36),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 144, 147, 160),
                        fontSize: 15,
                      ),
                      hintText: 'Search by ID, first name, Email, phone... ',
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: UnconstrainedBox(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    'Filter By    ',
                    style: GoogleFonts.signika(color: const Color.fromARGB(255, 175, 189, 252), fontSize: 24),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(filter == 0 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(140, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('ID', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            filter = 0;
                            searchController.text = '';
                          });
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(filter == 1 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(140, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('First name', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            filter = 1;
                            searchController.text = '';
                          });
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(filter == 2 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(140, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('Email', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            filter = 2;
                            searchController.text = '';
                          });
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(filter == 3 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(140, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text(
                          'Phone Number',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          setState(() {
                            filter = 3;
                            searchController.text = '';
                          });
                        },
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0, bottom: 200),
            child: SizedBox(
              width: dw,
              height: 250,
              child: PageView.custom(
                scrollBehavior: DesktopScrollBehavior(),
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                controller: pageController,
                childrenDelegate: SliverChildBuilderDelegate((context, page) {
                  double scale = page == currentPage ? 1 : 0.7;
                  return TweenAnimationBuilder<double>(
                      tween: Tween(begin: scale, end: scale),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: ManagerWidget(manager: filteredManagers[page]));
                }, childCount: filteredManagers.length),
                scrollDirection: Axis.horizontal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
