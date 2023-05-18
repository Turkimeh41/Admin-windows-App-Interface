// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Dialogs/user_dialog.dart';
import '../USER_SCREEN/latestuser_widget.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController controller;
  @override
  void initState() {
    _scrollController = ScrollController();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insUsers = Provider.of<Users>(context);
    final latestUsers = insUsers.latest();
    return Stack(
      children: [
        //Background Container
        Positioned.fill(
            child: Container(
          color: const Color.fromARGB(255, 14, 13, 19),
        )),
        Positioned(
            top: 15,
            left: 15,
            height: 230,
            width: 640,
            child: Container(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 20, 18, 26), borderRadius: BorderRadius.circular(15)),
            )),
        Positioned(
            top: 300,
            left: 15,
            height: 230,
            width: 640,
            child: Container(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 20, 18, 26), borderRadius: BorderRadius.circular(15)),
            )),

        Positioned(
            top: 50,
            left: 70,
            child: Text(
              'Users',
              style: GoogleFonts.signika(color: Colors.white, fontSize: 30),
            )),
        Positioned(
            top: 90,
            left: 70,
            child: Text(
              'Users can be added here from this easily,\n adding should be only for special use cases! ',
              style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18.5),
            )),
        Positioned(
            top: 180,
            left: 435,
            child: ElevatedButton(
                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(200, 50)), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124))),
                onPressed: () => UserDialog.addDialog(context, insUsers),
                child: Text(
                  'Add a new user',
                  style: GoogleFonts.signika(fontSize: 24),
                ))),
        //Searching User
        Positioned(
            top: 320,
            left: 70,
            child: Text(
              'User Search Mechanism',
              style: GoogleFonts.signika(color: Colors.white, fontSize: 26),
            )),
        Positioned(
            top: 370,
            left: 70,
            child: Text(
              'you can search for users over huge list,\n and do the appropiate action for them!',
              style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18.5),
            )),
        Positioned(
            top: 460,
            left: 435,
            child: ElevatedButton(
                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(200, 50)), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124))),
                onPressed: () => UserDialog.searchDialog(context, insUsers, controller),
                child: Text(
                  'Search',
                  style: GoogleFonts.signika(color: Colors.white, fontSize: 26.5),
                ))),
        //Latest Users
        Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.only(top: 8),
              width: 460,
              height: 400,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 20, 18, 26), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Latest Registered Users',
                      style: GoogleFonts.signika(color: Colors.white, fontSize: 28),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          'NAME',
                          style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          'REGISTERED',
                          style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      )
                    ]),
                  ),
                  Expanded(
                    child: VsScrollbar(
                      controller: _scrollController,
                      style: const VsScrollbarStyle(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView.separated(
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              return LatestUserWidget(user: latestUsers[index]);
                            },
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: latestUsers.length),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
