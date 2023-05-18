import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Model/anonymous_user_model.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnonymousWidget extends StatefulWidget {
  const AnonymousWidget({required this.anonymous, super.key});
  final AnonymousUser anonymous;
  @override
  State<AnonymousWidget> createState() => _AnonymousWidgetState();
}

class _AnonymousWidgetState extends State<AnonymousWidget> {
  bool disableLoading = false;
  bool deleteLoading = false;

  @override
  Widget build(BuildContext context) {
    final insAnonymousUsers = Provider.of<AnonymousUsers>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 20, 18, 26),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          //IMAGE
          Positioned(
              left: 50,
              top: 25,
              child: Row(
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), image: DecorationImage(image: CachedNetworkImageProvider(widget.anonymous.qrURL))),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              children: [TextSpan(text: widget.anonymous.id, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13, fontWeight: FontWeight.bold))],
                              text: 'ID: ',
                              style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: widget.anonymous.providerAccountID == 'null' ? '-' : widget.anonymous.providerAccountID,
                            style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: widget.anonymous.providerAccountID == 'null' ? 24 : 13, fontWeight: FontWeight.bold))
                      ], text: 'ProviderAccountID: ', style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: widget.anonymous.label == 'null' ? '-' : widget.anonymous.label,
                            style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: widget.anonymous.label == 'null' ? 24 : 13, fontWeight: FontWeight.bold))
                      ], text: 'Label: ', style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: widget.anonymous.assignedDate == null ? '-' : DateFormat("MMMM d, y, h:mm a").format(widget.anonymous.assignedDate!),
                            style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: widget.anonymous.label == 'null' ? 24 : 13, fontWeight: FontWeight.bold))
                      ], text: 'assignedDate: ', style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                    ],
                  )
                ],
              )),

          //REMOVE BUTTON
          Positioned(
            bottom: 15,
            right: deleteLoading == false ? 15 : 75,
            child: deleteLoading == false
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            deleteLoading = true;
                          });
                          await insAnonymousUsers.removeAnonymous(widget.anonymous.id);
                          setState(() {
                            deleteLoading = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 220,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 167, 27, 17), border: Border.all(width: 2, color: const Color.fromARGB(255, 119, 17, 9)), borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'Delete Anonymous User',
                            style: GoogleFonts.signika(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 8,
                    color: Color.fromARGB(255, 87, 14, 26),
                  ),
          ),
        ],
      ),
    );
  }
}
