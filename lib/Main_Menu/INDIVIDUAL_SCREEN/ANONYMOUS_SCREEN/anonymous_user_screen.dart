import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Custom/desktop_scrollbehavior.dart';
import 'package:hello_world/Main_Menu/INDIVIDUAL_SCREEN/ANONYMOUS_SCREEN/anonymous_widget.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AnonymousUserScreen extends StatefulWidget {
  const AnonymousUserScreen({super.key});

  @override
  State<AnonymousUserScreen> createState() => _AnonymousUserScreenState();
}

class _AnonymousUserScreenState extends State<AnonymousUserScreen> {
  late TextEditingController searchController;
  late FocusNode searchFocus;
  late PageController pageController;
  int _currentPage = 0;
  int _filter = 0;
  List<String> filters = ['ID', 'Provider Account iD', 'Label'];
  bool loading = false;
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
    final insAnonymous = Provider.of<AnonymousUsers>(context);
    final filteredManagers = insAnonymous.filteredAnonymous(searchController.text, _filter);

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
                        'Anonymous Users',
                        style: GoogleFonts.signika(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, top: 8.0),
                      child: Text(
                        'First generate a new template anonymous data that to be assigned\n  to a user by the manager',
                        style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18.5),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: loading == false
                            ? ElevatedButton(
                                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(300, 50)), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124))),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await insAnonymous.generateAnonymous();
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Text(
                                  'Generate new Anonymous data',
                                  style: GoogleFonts.signika(fontSize: 20),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(right: 120, top: 10),
                                child: Transform.scale(scaleX: 1.5, scaleY: 1.5, child: Lottie.asset('assets/animations/cube_loading_v2.json')),
                              ),
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
                    onChanged: (_) {
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
                      hintText: 'Search by ${filters[_filter]} ',
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
                            backgroundColor: MaterialStatePropertyAll(_filter == 0 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(180, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('Anonymous ID', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            _filter = 0;
                            searchController.text = '';
                            pageController.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeOutSine);
                          });
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(_filter == 1 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(180, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('ProviderAccount ID', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            _filter = 1;
                            searchController.text = '';
                            pageController.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeOutSine);
                          });
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(_filter == 2 ? const Color.fromARGB(255, 119, 19, 119) : const Color.fromARGB(255, 20, 18, 27)),
                            fixedSize: const MaterialStatePropertyAll(Size(180, 40)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        child: Text('Label', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            _filter = 2;
                            searchController.text = '';
                            pageController.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeOutSine);
                          });
                        },
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0, bottom: 200),
            child: SizedBox(
              width: dw,
              height: 200,
              child: PageView.custom(
                scrollBehavior: DesktopScrollBehavior(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                controller: pageController,
                childrenDelegate: SliverChildBuilderDelegate((context, page) {
                  double scale = page == _currentPage ? 1 : 0.6;
                  return TweenAnimationBuilder<double>(
                      tween: Tween(begin: scale, end: scale),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: AnonymousWidget(anonymous: filteredManagers[page]));
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
