// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';
import 'dart:developer' as l;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Provider/activites_provider.dart';
import 'package:hello_world/Model/activity_model.dart';
import 'package:hello_world/Dialogs/activity_dialog.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:keyboard_event/keyboard_event.dart';
import 'package:window_manager/window_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:chalkdart/chalk.dart';
import 'package:hello_world/admin_provider.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key, required this.activity});
  final Activity activity;
  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> with SingleTickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController typeController;
  late TextEditingController durationController;
  late TextEditingController seatsController;
  late AnimationController controller;
  late Animation<double> editAnimation;
  late Animation<double> submitAnimation;
  var priceFormatter = MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[\d.]+')}, type: MaskAutoCompletionType.lazy);
  var durationFormatter = MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  KeyboardEvent keyboard = KeyboardEvent();
  XFile? file;
  bool edit = false;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.activity.name);
    priceController = TextEditingController(text: widget.activity.price.toString());
    typeController = TextEditingController(text: widget.activity.type);
    durationController = TextEditingController(text: widget.activity.duration.toString());
    seatsController = TextEditingController(text: widget.activity.seats.toString());
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    editAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    submitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      keyboard.startListening((keyEvent) async {
        if (keyEvent.isKeyDown && await windowManager.isFocused()) {
          final keyPressed = keyEvent.vkCode;

          switch (keyPressed) {
            //ESC to close the activity details screen
            case 27:
              Navigator.of(context).pop();
              break;

//F1 to show window width and height sizes
            case 112:
              final size = await windowManager.getSize();
              l.log(chalk.green.bold("Width of the window: ${size.width}"));
              l.log(chalk.green.bold("Height of the window: ${size.height}"));
              l.log(chalk.green.bold("=============================="));
              break;
          }
        }
      });
    });
    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    keyboard.cancelListening();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dh = MediaQuery.of(context).size.height;
    final dw = MediaQuery.of(context).size.width;
    final insActivites = Provider.of<Activites>(context, listen: true);
    final insAdmin = Provider.of<Admin>(context, listen: false);
    return Scaffold(
      body: Container(
          height: dh,
          width: dw,
          padding: const EdgeInsets.all(48),
          color: const Color.fromARGB(255, 14, 13, 19),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color.fromARGB(255, 20, 20, 29)),
                      width: 800,
                      height: dh - 100,
                    ),
                    Positioned(
                        bottom: 50,
                        width: 400,
                        child: Opacity(
                            opacity: editAnimation.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => ActivityDialog.switchDialog(context: context, activites: insActivites, activityID: widget.activity.id, enabled: widget.activity.enabled),
                                  child: Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: widget.activity.enabled ? const Color.fromARGB(255, 226, 204, 4) : const Color.fromARGB(255, 26, 121, 29)),
                                    width: 52,
                                    height: 52,
                                    child: Icon(
                                      widget.activity.enabled ? Icons.disabled_by_default : Icons.start,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      controller.forward();
                                      edit = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue[800]),
                                    width: 52,
                                    height: 52,
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => ActivityDialog.deleteDialog(context: context, activites: insActivites, activityiD: widget.activity.id),
                                  child: Container(
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 155, 27, 18)),
                                    width: 52,
                                    height: 52,
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                    Positioned(
                        bottom: 50,
                        left: 200,
                        child: Opacity(
                            opacity: submitAnimation.value,
                            child: !edit
                                ? null
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        edit = false;
                                        controller.reverse();
                                      });
                                    },
                                    mouseCursor: SystemMouseCursors.click,
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 199, 34, 22)),
                                      child: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ))),
                    Positioned(
                        bottom: 50,
                        right: 200,
                        child: Opacity(
                            opacity: submitAnimation.value,
                            child: !edit
                                ? null
                                : InkWell(
                                    onTap: () async => ActivityDialog.confirmDialog(
                                        context,
                                        insActivites,
                                        widget.activity.id,
                                        nameController.text,
                                        typeController.text,
                                        int.parse(durationController.text),
                                        int.parse(seatsController.text),
                                        double.parse(priceController.text),
                                        file != null && file!.path.isNotEmpty ? await file!.readAsBytes() : null),
                                    mouseCursor: SystemMouseCursors.click,
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 42, 128, 16)),
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ))),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );

                      if (result != null && result.files.isNotEmpty) {
                        setState(() {
                          file = XFile(result.files.single.path!);
                        });
                      }
                    },
                    child: Hero(
                        tag: widget.activity.id,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    file != null && file!.path.isNotEmpty
                                        ? Image.file(File(file!.path), fit: BoxFit.cover, width: 600, height: 350)
                                        : CachedNetworkImage(imageUrl: widget.activity.imgURL, fit: BoxFit.cover, width: 600, height: 350),
                                    Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 18, 78, 128),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )))),
                  ),
                ),
              ),
              Positioned(
                  top: 480,
                  child: SizedBox(
                      width: 500,
                      child: Column(
                        children: [
                          Text('Activity Name', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                          Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 15),
                              width: 300,
                              height: 47,
                              child: TextField(
                                enabled: edit,
                                controller: nameController,
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: edit ? const Color.fromARGB(255, 63, 63, 83) : const Color.fromARGB(255, 36, 36, 49),
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
                                enabled: edit,
                                inputFormatters: [priceFormatter],
                                keyboardType: TextInputType.number,
                                controller: priceController,
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                decoration: InputDecoration(
                                    suffix: const Icon(
                                      Icons.monetization_on_outlined,
                                      color: Color.fromARGB(255, 26, 112, 28),
                                    ),
                                    filled: true,
                                    fillColor: edit ? const Color.fromARGB(255, 63, 63, 83) : const Color.fromARGB(255, 36, 36, 49),
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
                                enabled: edit,
                                controller: typeController,
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: edit ? const Color.fromARGB(255, 63, 63, 83) : const Color.fromARGB(255, 36, 36, 49),
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
                                enabled: edit,
                                inputFormatters: [durationFormatter],
                                keyboardType: TextInputType.number,
                                controller: durationController,
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: edit ? const Color.fromARGB(255, 63, 63, 83) : const Color.fromARGB(255, 36, 36, 49),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                              )),
                          Text('seats', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                          Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 15),
                              width: 300,
                              height: 47,
                              child: TextField(
                                enabled: edit,
                                controller: seatsController,
                                inputFormatters: [durationFormatter],
                                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: edit ? const Color.fromARGB(255, 63, 63, 83) : const Color.fromARGB(255, 36, 36, 49),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.purple))),
                              )),
                        ],
                      ))),
              Positioned(
                  top: 70,
                  right: 270,
                  child: Column(
                    children: [
                      IconButton(
                          color: Colors.white,
                          iconSize: 52,
                          onPressed: () async {
                            await windowManager.setResizable(true);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.cancel_outlined)),
                      Text(
                        'ESC',
                        style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
