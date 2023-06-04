import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Model/activity_model.dart';

class ActivityMontiorWidget extends StatelessWidget {
  const ActivityMontiorWidget({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 47, 43, 56),
      ),
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 5,
            child: Container(
              width: 292,
              height: 172,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(activity.imgURL))),
            ),
          ),
          Positioned(
              bottom: 20,
              child: Text(
                'Currently theres ${activity.currentUsers == null ? '-' : "${activity.currentUsers}"}/${activity.seats} of Users',
                style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
    );
  }
}
