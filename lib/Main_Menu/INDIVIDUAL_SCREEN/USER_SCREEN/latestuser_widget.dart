// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Provider/user_provider.dart';
import 'package:hello_world/Provider/users_provider.dart';

class LatestUserWidget extends StatefulWidget {
  const LatestUserWidget({super.key});

  @override
  State<LatestUserWidget> createState() => _LatestUserWidgetState();
}

class _LatestUserWidgetState extends State<LatestUserWidget> {
  @override
  Widget build(BuildContext context) {
    final insUser = Provider.of<User>(context);
    final insUsers = Provider.of<Users>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: 250,
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(right: 10), child: CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/placeholder.png'))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insUser.username,
                      style: GoogleFonts.signika(color: Colors.white, fontSize: 16),
                    ),
                    Text(insUser.email, style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 12))
                  ],
                ),
              ],
            )),
        SizedBox(
          width: 150,
          child: Text(
            insUser.formatDate(),
            style: GoogleFonts.signika(color: Colors.green[500], fontSize: 16),
          ),
        ),
        SizedBox(
          width: 30,
          child: IconButton(
              onPressed: () {
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
                                    'U will not be able to revoke after deleting this user, are you sure you wanna proceed?',
                                    style: GoogleFonts.signika(color: const Color.fromARGB(255, 116, 111, 133), fontSize: 18),
                                  ),
                                ),
                                StatefulBuilder(builder: (context, setStateful) {
                                  return Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      height: 75,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                                      child: loading
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 8,
                                              color: Color.fromARGB(255, 87, 14, 26),
                                            )
                                          : ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(Colors.red[900]),
                                                  fixedSize: const MaterialStatePropertyAll(Size.fromHeight(45)),
                                                  shape:
                                                      MaterialStatePropertyAll(RoundedRectangleBorder(side: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)))),
                                              onPressed: () async {
                                                setStateful(() {
                                                  loading = true;
                                                });
                                                await insUsers.removeUser(insUser.id);

                                                setStateful(() {
                                                  loading = false;
                                                });
                                                Navigator.of(context).pop();
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
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        )
      ],
    );
  }
}
