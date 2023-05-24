// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Dialogs/user_dialog.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Model/user_model.dart';
import 'package:hello_world/Provider/users_provider.dart';

class LatestUserWidget extends StatefulWidget {
  const LatestUserWidget({super.key, required this.user});
  final User user;
  @override
  State<LatestUserWidget> createState() => _LatestUserWidgetState();
}

class _LatestUserWidgetState extends State<LatestUserWidget> {
  @override
  Widget build(BuildContext context) {
    final insUsers = Provider.of<Users>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: 250,
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: widget.user.imgURL == null
                        ? const CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/placeholder.png'))
                        : CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(widget.user.imgURL!),
                          )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.username,
                      style: GoogleFonts.signika(color: Colors.white, fontSize: 16),
                    ),
                    Text(widget.user.email, style: GoogleFonts.signika(color: const Color.fromARGB(255, 133, 136, 150), fontSize: 12))
                  ],
                ),
              ],
            )),
        SizedBox(
          width: 150,
          child: Text(
            widget.user.formatDate(),
            style: GoogleFonts.signika(color: Colors.green[500], fontSize: 16),
          ),
        ),
        SizedBox(
          width: 30,
          child: IconButton(
              onPressed: () => UserDialog.deleteDialog(context: context, insUsers: insUsers, id: widget.user.id, userNotifierID: null, animationController: null),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        )
      ],
    );
  }
}
