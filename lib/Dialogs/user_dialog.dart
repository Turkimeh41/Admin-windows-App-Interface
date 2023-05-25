// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Handler/screen_handler.dart';
import 'package:hello_world/LOGIN_SCREEN/login_screen.dart';
import 'package:hello_world/Main_Menu/INDIVIDUAL_SCREEN/USER_SCREEN/edit_container.dart';
import 'package:hello_world/Main_Menu/INDIVIDUAL_SCREEN/USER_SCREEN/user_widget.dart';
import 'package:hello_world/Provider/position.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'package:hello_world/admin_provider.dart';
import 'package:provider/provider.dart';

class UserDialog {
  static void addDialog(BuildContext context, Users insUsers) {
    showDialog(
        context: context,
        builder: (context) {
          bool loading = false;
          int? gender;
          var maskFormatter = MaskTextInputFormatter(mask: '## ### ####');
          TextEditingController firstName = TextEditingController();
          TextEditingController lastName = TextEditingController();
          TextEditingController username = TextEditingController();
          TextEditingController password = TextEditingController();
          TextEditingController email = TextEditingController();
          TextEditingController phone = TextEditingController();

          return Dialog(
              backgroundColor: const Color.fromARGB(255, 23, 23, 33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                width: 560,
                height: 840,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add User',
                            style: GoogleFonts.signika(color: Colors.white, fontSize: 20.5),
                          ),
                          IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.cancel_outlined, color: Colors.amber[600]))
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        height: 652,
                        color: const Color.fromARGB(255, 16, 14, 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'First name',
                                        style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          width: 240,
                                          height: 47,
                                          child: TextField(
                                            controller: firstName,
                                            style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: const Color.fromARGB(255, 23, 23, 33),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                          ))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Last name', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                      Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          width: 240,
                                          height: 47,
                                          child: TextField(
                                              controller: lastName,
                                              style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: const Color.fromARGB(255, 23, 23, 33),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple)),
                                              )))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Username', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                                    width: 500,
                                    height: 47,
                                    child: TextField(
                                      controller: username,
                                      style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color.fromARGB(255, 23, 23, 33),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                    )),
                                Text('Password', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                                    width: 500,
                                    height: 47,
                                    child: TextField(
                                      obscureText: true,
                                      controller: password,
                                      style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color.fromARGB(255, 23, 23, 33),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                    )),
                                Text('Email Address', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                                    width: 500,
                                    height: 47,
                                    child: TextField(
                                      controller: email,
                                      style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color.fromARGB(255, 23, 23, 33),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                    )),
                                Text('Gender', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                StatefulBuilder(builder: (context, setStateful) {
                                  return SizedBox(
                                    height: 120,
                                    width: 140,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Transform.scale(
                                              scaleX: 1.2,
                                              scaleY: 1.2,
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(color: gender == 0 ? Colors.transparent : const Color.fromARGB(255, 5, 5, 5), shape: BoxShape.circle),
                                                child: Radio(
                                                    fillColor: gender != 0 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                    value: 0,
                                                    groupValue: gender,
                                                    onChanged: (val) {
                                                      setStateful(() {
                                                        gender = val!;
                                                      });
                                                    }),
                                              ),
                                            ),
                                            SizedBox(width: 80, child: Text('Male', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Transform.scale(
                                              scaleX: 1.2,
                                              scaleY: 1.2,
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(color: gender == 1 ? Colors.transparent : const Color.fromARGB(255, 5, 5, 5), shape: BoxShape.circle),
                                                child: Radio(
                                                    fillColor: gender != 1 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                    value: 1,
                                                    groupValue: gender,
                                                    onChanged: (val) {
                                                      setStateful(() {
                                                        gender = val!;
                                                      });
                                                    }),
                                              ),
                                            ),
                                            SizedBox(width: 80, child: Text('Female', style: GoogleFonts.signika(color: Colors.white, fontSize: 16)))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                Text('Phone Number', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                                    width: 500,
                                    height: 47,
                                    child: TextFormField(
                                        controller: phone,
                                        inputFormatters: [maskFormatter],
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.signika(fontSize: 18, color: Colors.white),
                                        decoration: InputDecoration(
                                          prefix: Text(
                                            '+966  ',
                                            style: GoogleFonts.signika(color: const Color.fromARGB(255, 115, 14, 124), fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          filled: true,
                                          fillColor: const Color.fromARGB(255, 23, 23, 33),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple)),
                                          errorStyle: const TextStyle(fontSize: 9),
                                        ))),
                              ],
                            ),
                          ],
                        )),
                    StatefulBuilder(builder: (context, setStateful) {
                      return Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(right: loading ? 50 : 25),
                          height: 60,
                          decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          child: loading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 8,
                                  color: Color.fromARGB(255, 87, 14, 26),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                      fixedSize: const MaterialStatePropertyAll(Size(120, 45)),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(side: const BorderSide(color: Color.fromARGB(255, 72, 9, 78), width: 2), borderRadius: BorderRadius.circular(15)))),
                                  onPressed: () async {
                                    setStateful(() {
                                      loading = true;
                                    });
                                    await insUsers.addUser(firstName.text, lastName.text, email.text, phone.text, username.text, password.text, gender!);

                                    setStateful(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Add User',
                                    style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                  )));
                    })
                  ],
                ),
              ));
        });
  }

  static void searchDialog(BuildContext context, Users insUsers, AnimationController opacityController) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController searchController = TextEditingController();
          FocusNode searchFocus = FocusNode();
          bool filterMenu = false;
          int filter = 0;
          int sort = 0;
          bool ascending = true;
          ValueNotifier<String> userNotifierID = ValueNotifier<String>('');
          Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: opacityController, curve: Curves.linear));
          return StatefulBuilder(builder: (context, setStateful) {
            final filteredSortedList = insUsers.filter(searchController.text, filter, sort, ascending);
            searchController.addListener(() {
              setStateful(() {});
            });
            opacityController.addListener(() {
              if (context.mounted) {
                setStateful(() {});
              }
            });
            return GestureDetector(
              onTap: () {
                opacityController.reset();
                userNotifierID.value = '';
              },
              child: Dialog(
                backgroundColor: const Color.fromARGB(255, 23, 23, 33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Provider(
                    create: (context) => Positions(),
                    builder: (context, child) {
                      return Consumer<Positions>(builder: (context, position, child) {
                        return SizedBox(
                          width: 1400,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 400,
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'Total Users: ',
                                          style: GoogleFonts.signika(color: Colors.white, fontSize: 16),
                                          children: [TextSpan(text: '${insUsers.users.length}', style: GoogleFonts.signika(color: const Color.fromARGB(255, 175, 189, 252)))])),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 18, left: 8, right: 20, bottom: 5),
                                    decoration:
                                        const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                    child: SizedBox(
                                      height: 45,
                                      width: 600,
                                      child: TextField(
                                        focusNode: searchFocus,
                                        textAlign: TextAlign.start,
                                        controller: searchController,
                                        style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              setStateful(() {
                                                filterMenu = !filterMenu;
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
                                          fillColor: const Color.fromARGB(255, 16, 14, 20),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          hintStyle: const TextStyle(
                                            color: Color.fromARGB(255, 144, 147, 160),
                                            fontSize: 15,
                                          ),
                                          hintText: 'Search by ID, username, Phone Number, Email... ',
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 200,
                                ),
                                IconButton(
                                    hoverColor: Colors.transparent,
                                    enableFeedback: false,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      size: 38,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            AnimatedContainer(
                              margin: const EdgeInsets.only(bottom: 15),
                              duration: const Duration(milliseconds: 100),
                              height: filterMenu ? 60 : 0,
                              width: 525,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                  color: Color.fromARGB(255, 14, 12, 17)),
                              child: filterMenu
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(color: filter == 0 ? Colors.transparent : const Color.fromARGB(255, 23, 23, 33), shape: BoxShape.circle),
                                              child: Radio(
                                                  fillColor: filter != 0 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                  value: 0,
                                                  groupValue: filter,
                                                  onChanged: (val) {
                                                    setStateful(() {
                                                      filter = val!;
                                                    });
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text('ID', style: GoogleFonts.signika(color: Colors.white, fontSize: 15)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(color: filter == 1 ? Colors.transparent : const Color.fromARGB(255, 23, 23, 33), shape: BoxShape.circle),
                                              child: Radio(
                                                  fillColor: filter != 1 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                  value: 1,
                                                  groupValue: filter,
                                                  onChanged: (val) {
                                                    setStateful(() {
                                                      filter = val!;
                                                    });
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text('Username', style: GoogleFonts.signika(color: Colors.white, fontSize: 15)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(color: filter == 2 ? Colors.transparent : const Color.fromARGB(255, 23, 23, 33), shape: BoxShape.circle),
                                              child: Radio(
                                                  fillColor: filter != 2 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                  value: 2,
                                                  groupValue: filter,
                                                  onChanged: (val) {
                                                    setStateful(() {
                                                      filter = val!;
                                                    });
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Phone Number',
                                              style: GoogleFonts.signika(color: Colors.white, fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(color: filter == 3 ? Colors.transparent : const Color.fromARGB(255, 23, 23, 33), shape: BoxShape.circle),
                                              child: Radio(
                                                  fillColor: filter != 3 ? const MaterialStatePropertyAll(Colors.transparent) : const MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)),
                                                  value: 3,
                                                  groupValue: filter,
                                                  onChanged: (val) {
                                                    setStateful(() {
                                                      filter = val!;
                                                    });
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text('Email', style: GoogleFonts.signika(color: Colors.white, fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    )
                                  : null,
                            ),
                            Expanded(
                              child: Container(
                                width: 1200,
                                decoration: BoxDecoration(color: const Color.fromARGB(255, 16, 14, 20), borderRadius: BorderRadius.circular(15)),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 110,
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              setStateful(() {
                                                if (sort == 0) {
                                                  ascending = !ascending;
                                                } else {
                                                  sort = 0;
                                                  ascending = true;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('ID', style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18)),
                                                sort == 0 ? Icon(ascending == true ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: const Color.fromARGB(255, 231, 215, 215)) : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 120,
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              setStateful(() {
                                                if (sort == 1) {
                                                  ascending = !ascending;
                                                } else {
                                                  sort = 1;
                                                  ascending = true;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Username', style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18)),
                                                sort == 1 ? Icon(ascending == true ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: const Color.fromARGB(255, 231, 215, 215)) : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 230,
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              setStateful(() {
                                                if (sort == 2) {
                                                  ascending = !ascending;
                                                } else {
                                                  sort = 2;
                                                  ascending = true;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Registered', style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18)),
                                                sort == 2 ? Icon(ascending == true ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: const Color.fromARGB(255, 231, 215, 215)) : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 56,
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [Text('Phone Number', style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18))]),
                                        const SizedBox(
                                          width: 45,
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              setStateful(() {
                                                if (sort == 3) {
                                                  ascending = !ascending;
                                                } else {
                                                  sort = 3;
                                                  ascending = true;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Status', style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 18)),
                                                sort == 3 ? Icon(ascending == true ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: const Color.fromARGB(255, 231, 215, 215)) : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 130,
                                        ),
                                        const Icon(
                                          size: 28,
                                          Icons.manage_accounts,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1.5,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                        final height = boxConstraints.maxHeight;
                                        return Stack(
                                          children: [
                                            SizedBox(
                                              height: height,
                                              child: ListView.separated(
                                                  itemBuilder: (context, i) {
                                                    final singleUser = filteredSortedList[i];
                                                    return UserWidget(
                                                      user: singleUser,
                                                      valueNotifier: userNotifierID,
                                                      controller: opacityController,
                                                    );
                                                  },
                                                  separatorBuilder: (context, i) => const Divider(),
                                                  itemCount: filteredSortedList.length),
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable: userNotifierID,
                                                builder: (context, id, child) {
                                                  final renderManager = position.renderManager;
                                                  return id == ''
                                                      ? const SizedBox()
                                                      : Positioned(
                                                          left: 930,
                                                          top: 20 + (renderManager.getRenderData(id)!.yCenter - renderManager.getRenderData(position.firstID())!.yCenter),
                                                          child: FadeTransition(
                                                            opacity: animation,
                                                            child: EditContainer(userID: id, setState: setStateful, userNotifierID: userNotifierID, opacityController: opacityController),
                                                          ),
                                                        );
                                                })
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ]),
                        );
                      });
                    }),
              ),
            );
          });
        });
  }

  static void deleteDialog({required BuildContext context, required Users insUsers, required String id, ValueNotifier? userNotifierID, AnimationController? animationController}) {
    showDialog(
        context: context,
        builder: (context) {
          bool loading = false;
          return Dialog(
              backgroundColor: const Color.fromARGB(255, 23, 23, 33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                width: 500,
                height: 275,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete User',
                            style: GoogleFonts.signika(color: Colors.white, fontSize: 19.5),
                          ),
                          IconButton(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.amber[600] /* Color.fromARGB(255, 121, 26, 19) */,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      height: 125,
                      color: const Color.fromARGB(255, 20, 18, 26),
                      child: Text(
                        'You will not be able to revoke after deleting this user, are you sure you wanna proceed?',
                        style: GoogleFonts.signika(color: const Color.fromARGB(255, 116, 111, 133), fontSize: 18),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setStateful) {
                      return Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          height: 75,
                          decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          child: loading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 8,
                                  color: Color.fromARGB(255, 87, 14, 26),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.red[900]),
                                      fixedSize: const MaterialStatePropertyAll(Size.fromHeight(45)),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(side: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)))),
                                  onPressed: () async {
                                    setStateful(() {
                                      loading = true;
                                    });

                                    await insUsers.removeUser(id);

                                    setStateful(() {
                                      loading = false;
                                    });
                                    if (userNotifierID != null && animationController != null) {
                                      Navigator.of(context).pop();
                                      animationController.reset();
                                      userNotifierID.value = '';
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    'Delete User',
                                    style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                  )));
                    })
                  ],
                ),
              ));
        });
  }

  static void logoutDialog(BuildContext context, Admin admin) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: const Color.fromARGB(255, 23, 23, 33),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
              width: 500,
              height: 275,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logout',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 19.5),
                        ),
                        IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.cancel_outlined, color: Colors.amber[600]))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    height: 125,
                    color: const Color.fromARGB(255, 20, 18, 26),
                    child: Text(
                      'Are you sure you wanna logout?',
                      style: GoogleFonts.acme(color: const Color.fromARGB(255, 116, 111, 133), fontSize: 18),
                    ),
                  ),
                  StatefulBuilder(builder: (context, setStateful) {
                    return Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        height: 75,
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.red[900]),
                                fixedSize: const MaterialStatePropertyAll(Size(160, 45)),
                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(side: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)))),
                            onPressed: () async {
                              admin.clear();
                              Screen.page = 0;
                              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
                            },
                            child: Text(
                              'Logout',
                              style: GoogleFonts.acme(color: Colors.white, fontSize: 22),
                            )));
                  })
                ],
              ),
            ));
      },
    );
  }

  static Future<void> switchDialog(
      {required BuildContext context,
      required Users insUsers,
      required String userID,
      required bool status,
      required ValueNotifier userNotifierID,
      required AnimationController animationController}) async {
    await showDialog(
        context: context,
        builder: (context) {
          bool loading = false;
          return Dialog(
              backgroundColor: const Color.fromARGB(255, 23, 23, 33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                width: 500,
                height: 275,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status == true ? 'Disable User' : 'Enable User',
                            style: GoogleFonts.signika(color: Colors.white, fontSize: 19.5),
                          ),
                          IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.cancel_outlined, color: Colors.amber[600]))
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      height: 125,
                      color: const Color.fromARGB(255, 20, 18, 26),
                      child: Text(
                        status == true
                            ? 'Are you sure you wanna disable this user, from interacting to the app?\n enabling can be done later.'
                            : 'Are you sure you wanna enable this user, to interact with the app?.',
                        style: GoogleFonts.signika(color: const Color.fromARGB(255, 116, 111, 133), fontSize: 18),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setStateful) {
                      return Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: loading ? 60 : 20),
                          height: 75,
                          decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          child: loading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 8,
                                  color: Color.fromARGB(255, 87, 14, 26),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(status == true ? Colors.red[900] : const Color.fromARGB(255, 17, 145, 22)),
                                      fixedSize: const MaterialStatePropertyAll(Size.fromHeight(45)),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                          side: BorderSide(color: status == true ? Colors.red : const Color.fromARGB(255, 50, 231, 56), width: 2), borderRadius: BorderRadius.circular(15)))),
                                  onPressed: () async {
                                    setStateful(() {
                                      loading = true;
                                    });
                                    await insUsers.switchUserStatus(userID);
                                    setStateful(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pop();
                                    animationController.reset();
                                    userNotifierID.value = '';
                                  },
                                  child: Text(
                                    status == true ? 'Disable User' : 'Enable User',
                                    style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                  )));
                    })
                  ],
                ),
              ));
        });
  }
}
