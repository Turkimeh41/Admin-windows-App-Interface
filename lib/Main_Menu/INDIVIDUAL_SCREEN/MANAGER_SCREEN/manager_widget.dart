import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Model/manager_model.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:provider/provider.dart';

class ManagerWidget extends StatefulWidget {
  const ManagerWidget({required this.manager, super.key});
  final Manager manager;

  @override
  State<ManagerWidget> createState() => _ManagerWidgetState();
}

class _ManagerWidgetState extends State<ManagerWidget> {
  bool disableLoading = false;
  bool deleteLoading = false;

  @override
  Widget build(BuildContext context) {
    final insManagers = Provider.of<Managers>(context, listen: false);
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
              top: 20,
              left: 40,
              child: widget.manager.img_link.length > 7
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(widget.manager.img_link),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/images/placeholder.png'),
                    )),
          Positioned(
              top: 25,
              left: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: widget.manager.id, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'ID: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: widget.manager.username, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'Username: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: widget.manager.first_name, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'First name: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: widget.manager.last_name, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'Last name: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: widget.manager.email_address, style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'Email: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                  RichText(
                      text: TextSpan(
                          children: [TextSpan(text: '+966 ${widget.manager.phone}', style: GoogleFonts.signika(color: const Color.fromARGB(255, 169, 102, 187), fontSize: 13.5))],
                          text: 'Phone: ',
                          style: GoogleFonts.signika(color: Colors.white, fontSize: 15))),
                ],
              )),
          //DISABLE BUTTON
          Positioned(
            bottom: 75,
            right: disableLoading == false ? 15 : 75,
            child: disableLoading == false
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            disableLoading = true;
                          });
                          await insManagers.switchManagerStatus(widget.manager.id);
                          setState(() {
                            disableLoading = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 160,
                          height: 40,
                          decoration: BoxDecoration(
                              color: widget.manager.enabled ? const Color.fromARGB(255, 207, 156, 4) : const Color.fromARGB(255, 28, 170, 33),
                              border: Border.all(width: 2, color: widget.manager.enabled ? const Color.fromARGB(255, 112, 80, 5) : const Color.fromARGB(255, 113, 211, 116)),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(widget.manager.enabled ? 'Disable Manager' : 'Enable Manager', style: GoogleFonts.signika(color: Colors.white, fontSize: 18)),
                        )),
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 8,
                    color: Color.fromARGB(255, 87, 14, 26),
                  ),
          ),

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
                          await insManagers.removeManager(widget.manager.id);
                          setState(() {
                            deleteLoading = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 160,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 167, 27, 17), border: Border.all(width: 2, color: const Color.fromARGB(255, 119, 17, 9)), borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'Delete Manager',
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
