// ignore_for_file: prefer_is_empty, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Handler/login_handler.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/admin_provider.dart';

class LoginFields extends StatefulWidget {
  const LoginFields({super.key});

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> with SingleTickerProviderStateMixin {
  bool obscurePass = true;
  bool mouseHover = false;
  @override
  void initState() {
    LoginHandler.init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LoginFields oldWidget) {
    LoginHandler.init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    LoginHandler.userController.dispose();
    LoginHandler.passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dh = MediaQuery.of(context).size.height;
    final admin = Provider.of<Admin>(context, listen: false);
    LoginHandler.context = context;
    return Positioned(
      top: dh * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
                child: AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (child, animation) {
                      {
                        return FadeTransition(opacity: animation, child: child);
                      }
                    },
                    child: LoginHandler.userFocus.hasFocus
                        ? const Icon(
                            Icons.admin_panel_settings,
                            color: Color.fromARGB(255, 202, 20, 202),
                            size: 28,
                            key: ValueKey('1'),
                          )
                        : const Icon(
                            Icons.admin_panel_settings_outlined,
                            color: Color.fromARGB(255, 73, 71, 73),
                            size: 22,
                            key: ValueKey('2'),
                          )),
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  focusNode: LoginHandler.userFocus,
                  controller: LoginHandler.userController,
                  decoration: InputDecoration(
                      errorText: LoginHandler.userError,
                      hintStyle: GoogleFonts.signika(color: const Color.fromARGB(255, 119, 121, 127)),
                      hintText: 'Username',
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 1,
                      )),
                      border: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 164, 148, 164))),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 2, 2),
                        width: 1,
                      )),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 3.5,
                      )),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 0, 0),
                        width: 1,
                      ))),
                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
                child: AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: LoginHandler.passFocus.hasFocus
                        ? const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 202, 20, 202),
                            size: 28,
                            key: ValueKey('3'),
                          )
                        : const Icon(
                            Icons.lock_outline,
                            color: Color.fromARGB(255, 73, 71, 73),
                            size: 22,
                            key: ValueKey('4'),
                          )),
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  focusNode: LoginHandler.passFocus,
                  controller: LoginHandler.passController,
                  obscureText: obscurePass,
                  decoration: InputDecoration(
                      errorText: LoginHandler.passError,
                      hintStyle: GoogleFonts.signika(color: const Color.fromARGB(255, 119, 121, 127)),
                      hintText: 'Password',
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 1,
                      )),
                      border: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 164, 148, 164))),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 2, 2),
                        width: 1,
                      )),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 3.5,
                      )),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 0, 0),
                        width: 1,
                      ))),
                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: obscurePass
                      ? IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          key: const ValueKey('0'),
                          color: obscurePass ? Colors.white : Colors.purple,
                          onPressed: () {
                            setState(() {
                              obscurePass = false;
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          key: const ValueKey('1'),
                          color: obscurePass ? Colors.white : Colors.purple,
                          onPressed: () {
                            setState(() {
                              obscurePass = true;
                            });
                          },
                        ))
            ],
          ),
          const SizedBox(
            height: 75,
          ),
          StatefulBuilder(builder: (context, setStateful) {
            LoginHandler.setStateful = setStateful;
            LoginHandler.setState = setState;
            return Row(
              children: [
                SizedBox(
                  width: LoginHandler.loading ? 180 : 82,
                ),
                LoginHandler.loading
                    ? const CircularProgressIndicator(
                        strokeWidth: 8,
                        color: Color.fromARGB(255, 87, 14, 26),
                      )
                    : MouseRegion(
                        cursor: MaterialStateMouseCursor.clickable,
                        onEnter: (event) {
                          setStateful(() {
                            mouseHover = true;
                          });
                        },
                        onExit: (event) {
                          setStateful(() {
                            mouseHover = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () => LoginHandler.submitButton(admin),
                          child: AnimatedContainer(
                              alignment: Alignment.center,
                              width: 220,
                              height: 40,
                              duration: const Duration(milliseconds: 700),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: mouseHover
                                      ? LinearGradient(
                                          colors: [Colors.purple[500]!, Colors.purple[700]!, Colors.purple[800]!, Colors.purple[900]!], begin: Alignment.bottomRight, end: Alignment.topLeft)
                                      : LinearGradient(colors: [Colors.blue[500]!, Colors.blue[600]!, Colors.blue[700]!, Colors.blue[800]!], begin: Alignment.bottomRight, end: Alignment.topLeft)),
                              child: Text(
                                'Login',
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 28),
                              )),
                        )),
              ],
            );
          }),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const SizedBox(
                width: 85,
              ),
              Visibility(
                visible: LoginHandler.errorVisible,
                child: Text(
                  'Invalid username, or password',
                  style: GoogleFonts.signika(color: Colors.red, fontSize: 18),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
