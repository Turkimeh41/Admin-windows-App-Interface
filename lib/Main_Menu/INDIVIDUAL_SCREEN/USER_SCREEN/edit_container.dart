import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/INDIVIDUAL_SCREEN/USER_SCREEN/user_dialog.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/Provider/users_provider.dart';

class EditContainer extends StatelessWidget {
  const EditContainer({super.key, required this.userID, required this.setState});
  final String userID;
  final void Function(void Function()) setState;
  @override
  Widget build(BuildContext context) {
    final insUsers = Provider.of<Users>(context, listen: false);
    final status = insUsers.getStatus(userID);
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 23, 23, 33), borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onHover: null,
              style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 23, 23, 33))),
              onPressed: () => UserDialog.deleteDialog(context: context, insUsers: insUsers, id: userID),
              child: Row(
                children: [
                  const Icon(
                    size: 32,
                    Icons.delete,
                    color: Color.fromARGB(255, 148, 25, 17),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text('Delete', style: GoogleFonts.signika(color: Colors.white, fontSize: 15))
                ],
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: const ButtonStyle(enableFeedback: false, overlayColor: MaterialStatePropertyAll(Colors.transparent), backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 23, 23, 33))),
              onPressed: () async {
                await UserDialog.switchDialog(context: context, insUsers: insUsers, userID: userID, status: status);
                setState(() {});
              },
              child: Row(
                children: [
                  Icon(
                    size: 32,
                    Icons.disabled_by_default_rounded,
                    color: status == true ? Colors.amber : const Color.fromARGB(255, 23, 122, 26),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(status == true ? 'Disable' : 'Enable', style: GoogleFonts.signika(color: Colors.white, fontSize: 15))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
