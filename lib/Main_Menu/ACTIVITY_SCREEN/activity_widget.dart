// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/ACTIVITY_SCREEN/activitesdetails_screen.dart';
import 'package:hello_world/Model/activity_model.dart';
import 'dart:ui';

import 'package:window_manager/window_manager.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({required this.activity, super.key});
  final Activity activity;
  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> blurAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  static const ColorFilter _greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  void initState() {
    _hoverController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    blurAnimation = Tween<double>(begin: 8.0, end: 0.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.linear));
    opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.linear));
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(CurvedAnimation(parent: _hoverController, curve: Curves.linear));
    super.initState();

    _hoverController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: scaleAnimation.value,
      scaleY: scaleAnimation.value,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          _hoverController.forward();
        },
        onExit: (event) {
          _hoverController.reverse();
        },
        child: GestureDetector(
          onTap: () async {
            await windowManager.setResizable(false);
            await windowManager.setSize(const Size(1680, 1122));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ActivityDetailsScreen(activity: widget.activity),
            ));
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ColorFiltered(
                  colorFilter: widget.activity.enabled
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.saturation,
                        )
                      : _greyscale,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: blurAnimation.value, sigmaY: blurAnimation.value),
                    child: Hero(
                      tag: widget.activity.id,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(widget.activity.imgURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      const Color.fromARGB(255, 0, 0, 0).withOpacity(0.0),
                      Colors.black.withOpacity(opacityAnimation.value),
                      Colors.black.withOpacity(opacityAnimation.value / 1.8),
                    ],
                    stops: const [0, 0.75, 1],
                  ),
                ),
              ),
              Positioned(top: 15, left: 15, child: Text(widget.activity.id, style: GoogleFonts.signika(color: Colors.white, fontSize: 16))),
              //name
              Positioned(bottom: 35, left: 18, child: Text(widget.activity.name, style: GoogleFonts.signika(color: Colors.white, fontSize: 32))),
              Positioned(bottom: 10, left: 18, child: Text("${widget.activity.price}\$", style: GoogleFonts.signika(color: Colors.purple, fontSize: 26, fontWeight: FontWeight.bold))),
              Positioned(
                  bottom: 5,
                  right: 18,
                  child: Text("${widget.activity.duration} min each", style: GoogleFonts.signika(color: const Color.fromARGB(255, 230, 205, 205), fontSize: 17.5, fontWeight: FontWeight.bold))),
              Positioned(
                  bottom: 20, right: 50, child: Text(widget.activity.type, style: GoogleFonts.signika(color: const Color.fromARGB(255, 230, 205, 205), fontSize: 17.5, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}
