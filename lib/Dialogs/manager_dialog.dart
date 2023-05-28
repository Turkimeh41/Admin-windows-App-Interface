// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerDialog {
  static void addDialog(BuildContext context, Managers insManagers) {
    showDialog(
        context: context,
        builder: (context) {
          bool loading = false;
          XFile? file;
          var maskFormatter = MaskTextInputFormatter(mask: '## ### ####');
          TextEditingController username = TextEditingController();
          TextEditingController firstName = TextEditingController();
          TextEditingController lastName = TextEditingController();
          TextEditingController password = TextEditingController();
          TextEditingController email = TextEditingController();
          TextEditingController phone = TextEditingController();

          return Dialog(
              backgroundColor: const Color.fromARGB(255, 23, 23, 33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: StatefulBuilder(builder: (context, setStateful) {
                return SizedBox(
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
                              'Add Manager',
                              style: GoogleFonts.signika(color: Colors.white, fontSize: 20.5),
                            ),
                            IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.cancel_outlined, color: Colors.amber[600]))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(20),
                            color: const Color.fromARGB(255, 16, 14, 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: MouseRegion(
                                    cursor: MaterialStateMouseCursor.clickable,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false,
                                              );
                                              if (result != null && result.files.isNotEmpty) {
                                                setStateful(() {
                                                  file = XFile(result.files.single.path!);
                                                });
                                              }
                                            },
                                            child: file == null
                                                ? const CircleAvatar(
                                                    radius: 48,
                                                    backgroundImage: AssetImage('assets/images/placeholder.png'),
                                                  )
                                                : CircleAvatar(
                                                    radius: 48,
                                                    backgroundImage: FileImage(File(file!.path)),
                                                  )),
                                        Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  size: 32,
                                                  Icons.edit,
                                                  color: Colors.blue[700],
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
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
                                          obscureText: false,
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
                      ),
                      StatefulBuilder(builder: (context, setStateful) {
                        return Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(top: 8),
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
                                        fixedSize: const MaterialStatePropertyAll(Size(180, 45)),
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(side: const BorderSide(color: Color.fromARGB(255, 101, 12, 109), width: 2), borderRadius: BorderRadius.circular(15)))),
                                    onPressed: () async {
                                      String? img_link;
                                      setStateful(() {
                                        loading = true;
                                      });
                                      if (file != null) {
                                        final Uint8List listBytes = await file!.readAsBytes();
                                        img_link = base64Encode(listBytes);
                                      }

                                      await insManagers.addManager(username.text, firstName.text, lastName.text, email.text, phone.text, password.text, img_link);

                                      setStateful(() {
                                        loading = false;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Add Manager',
                                      style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                    )));
                      })
                    ],
                  ),
                );
              }));
        });
  }
}
