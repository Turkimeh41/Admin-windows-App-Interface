// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Provider/activites_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'Custom/vertical_divider.dart' as custom;
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';

class ActivityDialog {
  static void addDialog(Activites activites, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          XFile? file;
          var priceFormatter = MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[\d.]+')}, type: MaskAutoCompletionType.lazy);
          var durationFormatter = MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
          TextEditingController name = TextEditingController();
          TextEditingController price = TextEditingController();
          TextEditingController type = TextEditingController();
          TextEditingController duration = TextEditingController();
          bool occupied = false;
          bool loading = false;
          return Dialog(
            backgroundColor: const Color.fromARGB(255, 23, 23, 33),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: StatefulBuilder(builder: (context, setStateful) {
              return SizedBox(
                  width: 1300,
                  height: 800,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 30),
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                'Add a New activity',
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Expanded(
                              child: Container(
                                color: const Color.fromARGB(255, 17, 17, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 1, child: Divider(thickness: 1.5)),
                                    const SizedBox(height: 20),
                                    Center(child: Text('Base Information ', style: GoogleFonts.signika(color: Colors.white, fontSize: 24))),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 30),
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Activity Name', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                            Container(
                                                margin: const EdgeInsets.only(top: 10, bottom: 15),
                                                width: 300,
                                                height: 47,
                                                child: TextField(
                                                  controller: name,
                                                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color.fromARGB(255, 30, 30, 43),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                                )),
                                            Text('Price', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                            Container(
                                                margin: const EdgeInsets.only(top: 10, bottom: 15),
                                                width: 300,
                                                height: 45,
                                                child: TextField(
                                                  inputFormatters: [priceFormatter],
                                                  keyboardType: TextInputType.number,
                                                  controller: price,
                                                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                                  decoration: InputDecoration(
                                                      suffix: const Icon(
                                                        Icons.monetization_on_outlined,
                                                        color: Color.fromARGB(255, 26, 112, 28),
                                                      ),
                                                      filled: true,
                                                      fillColor: const Color.fromARGB(255, 30, 30, 43),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                                )),
                                            Text('Type', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                            Container(
                                                margin: const EdgeInsets.only(top: 10, bottom: 15),
                                                width: 300,
                                                height: 47,
                                                child: TextField(
                                                  controller: type,
                                                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color.fromARGB(255, 30, 30, 43),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                                )),
                                            Text('Duration in minutes', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                                            Container(
                                                margin: const EdgeInsets.only(top: 10, bottom: 15),
                                                width: 300,
                                                height: 47,
                                                child: TextField(
                                                  inputFormatters: [durationFormatter],
                                                  keyboardType: TextInputType.number,
                                                  controller: duration,
                                                  style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color.fromARGB(255, 30, 30, 43),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                                                )),
                                          ],
                                        )),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          log("occupied now: $occupied");
                                          if (occupied == true) {
                                            return;
                                          }
                                          setStateful(() {
                                            log('rebuilding with occupied true');
                                            occupied = true;
                                          });

                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            type: FileType.image,
                                            allowMultiple: false,
                                          );

                                          if (result != null && result.files.isNotEmpty) {
                                            setStateful(() {
                                              file = XFile(result.files.single.path!);
                                              occupied = false;
                                            });
                                          } else {
                                            setStateful(() {
                                              occupied = false;
                                            });
                                          }
                                        },
                                        child: FocusableActionDetector(
                                          mouseCursor: SystemMouseCursors.click,
                                          child: DropTarget(
                                              onDragDone: (details) {
                                                if (details.files[0].path.isNotEmpty) {
                                                  setStateful(() {
                                                    file = XFile(details.files[0].path);
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                width: 600,
                                                height: 200,
                                                child: DottedBorder(
                                                    color: const Color.fromARGB(255, 68, 68, 75),
                                                    dashPattern: const [9],
                                                    strokeCap: StrokeCap.butt,
                                                    strokeWidth: 2,
                                                    child: SizedBox(
                                                      width: 600,
                                                      height: 200,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Transform.rotate(
                                                            angle: 3.13,
                                                            child: Icon(
                                                              size: 64,
                                                              Icons.upload,
                                                              color: const Color.fromARGB(255, 84, 84, 107).withOpacity(0.5),
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                                text: 'Choose a file',
                                                                style: GoogleFonts.signika(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 115, 14, 124),
                                                                  fontSize: 32,
                                                                ),
                                                                children: [
                                                                  TextSpan(text: ' or drag it here', style: GoogleFonts.signika(color: const Color.fromARGB(255, 84, 84, 107), fontSize: 32))
                                                                ]),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const custom.VerticalDivider(height: 1400, thickness: 1.5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            children: [
                              Text(
                                'Preview',
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 28),
                              ),
                              const SizedBox(height: 30),
                              const Divider(),
                              const SizedBox(height: 40),
                              Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 17, 17, 24)),
                                  width: 450,
                                  height: 230,
                                  child: file != null && file!.path.isNotEmpty ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(file!.path), fit: BoxFit.cover)) : null),
                              const SizedBox(
                                height: 250,
                              ),
                              loading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 8,
                                      color: Color.fromARGB(255, 87, 14, 26),
                                    )
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                          backgroundColor:
                                              MaterialStatePropertyAll(file != null && file!.path.isNotEmpty ? const Color.fromARGB(255, 115, 14, 124) : const Color.fromARGB(255, 94, 60, 97)),
                                          fixedSize: const MaterialStatePropertyAll(Size(360, 45))),
                                      onPressed: file != null && file!.path.isNotEmpty
                                          ? () async {
                                              setStateful(() {
                                                loading = true;
                                              });
                                              await activites.addActivity(name: name.text, type: type.text, duration: int.parse(duration.text), price: double.parse(price.text), image_file: file!);
                                              setStateful(() {
                                                loading = false;
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: Text(
                                        'Add Activity',
                                        style: GoogleFonts.signika(color: Colors.white, fontSize: 24),
                                      ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            }),
          );
        });
  }

  static void confirmDialog(BuildContext context, Activites insActivites, String id, String name, String type, int duration, double price, Uint8List? img) {
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
                          'Submit',
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
                      'Are you sure you wanna submit?',
                      style: GoogleFonts.acme(color: const Color.fromARGB(255, 116, 111, 133), fontSize: 18),
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
                                    backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 9, 133, 25)),
                                    fixedSize: const MaterialStatePropertyAll(Size(160, 45)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(side: const BorderSide(color: Color.fromARGB(255, 124, 204, 93), width: 2), borderRadius: BorderRadius.circular(15)))),
                                onPressed: () async {
                                  setStateful(() {
                                    loading = true;
                                  });
                                  await insActivites.editActivity(id: id, duration: duration, img: img, name: name, type: type, price: price);
                                  setStateful(() {
                                    loading = false;
                                  });
                                  int count = 0;
                                  Navigator.of(context).popUntil((route) {
                                    if (count == 2) {
                                      return true;
                                    } else {
                                      count++;
                                      return false;
                                    }
                                  });
                                },
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.acme(color: Colors.white, fontSize: 22),
                                )));
                  })
                ],
              ),
            ));
      },
    );
  }
}
