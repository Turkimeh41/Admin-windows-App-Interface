// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Provider/position.dart';
import 'package:hello_world/Model/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key, required this.user, required this.valueNotifier, required this.controller});
  final User user;
  final ValueNotifier valueNotifier;
  final AnimationController controller;
  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = Provider.of<Positions>(context, listen: false);
      position.addQueue(widget.user.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final position = Provider.of<Positions>(context);
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 180,
            alignment: Alignment.center,
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              widget.user.id,
              style: GoogleFonts.signika(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.user.imgURL == null
                    ? const CircleAvatar(backgroundImage: AssetImage('assets/images/placeholder.png'))
                    : CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.user.imgURL!), radius: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      widget.user.username,
                      style: GoogleFonts.signika(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16),
                    ),
                    Text(overflow: TextOverflow.ellipsis, maxLines: 1, widget.user.email, style: GoogleFonts.signika(color: const Color.fromARGB(255, 175, 189, 252), fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            DateFormat("MMMM d, y").format(widget.user.register_date),
            style: GoogleFonts.signika(color: const Color.fromARGB(255, 175, 189, 252), fontSize: 16),
          ),
          Text(widget.user.phone, style: GoogleFonts.signika(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16)),
          SizedBox(
            width: 60,
            child: Text(widget.user.enabled == true ? 'Enabled' : 'Disabled',
                style: GoogleFonts.signika(color: widget.user.enabled == true ? const Color.fromARGB(255, 32, 136, 35) : const Color.fromARGB(255, 134, 24, 16), fontSize: 16)),
          ),
          RenderMetricsObject(
            id: widget.user.id,
            manager: position.renderManager,
            child: ElevatedButton(
              onPressed: () {
                widget.controller.reset();
                widget.controller.forward();
                widget.valueNotifier.value = widget.user.id;
              },
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 14, 124)), fixedSize: MaterialStatePropertyAll(Size(150, 40))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit',
                    style: GoogleFonts.signika(color: Colors.white, fontSize: 20),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
