import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/ACTIVITY_SCREEN/activitesdetails_screen.dart';
import 'package:hello_world/Provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({super.key});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> blurAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  @override
  void initState() {
    _hoverController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    blurAnimation = Tween<double>(begin: 4.0, end: 0.0).animate(CurvedAnimation(parent: _hoverController, curve: Curves.linear));
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
    final insActivity = Provider.of<Activity>(context);
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
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ActivityDetailsScreen(activity: insActivity),
          )),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blurAnimation.value, sigmaY: blurAnimation.value),
                  child: Hero(
                    tag: insActivity.id,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(insActivity.img_link),
                          fit: BoxFit.cover,
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
              //name
              Positioned(bottom: 35, left: 18, child: Text(insActivity.name, style: GoogleFonts.signika(color: Colors.white, fontSize: 32))),
              Positioned(bottom: 10, left: 18, child: Text("${insActivity.price}\$", style: GoogleFonts.signika(color: Colors.purple, fontSize: 26, fontWeight: FontWeight.bold))),
              Positioned(
                  bottom: 5,
                  right: 18,
                  child: Text("${insActivity.duration} min each", style: GoogleFonts.signika(color: const Color.fromARGB(255, 230, 205, 205), fontSize: 17.5, fontWeight: FontWeight.bold))),
              Positioned(
                  bottom: 20, right: 50, child: Text(insActivity.type, style: GoogleFonts.signika(color: const Color.fromARGB(255, 230, 205, 205), fontSize: 17.5, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}
