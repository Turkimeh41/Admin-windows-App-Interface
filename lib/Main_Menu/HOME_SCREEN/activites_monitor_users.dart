import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Main_Menu/HOME_SCREEN/activity_monitor_widget.dart';
import 'package:hello_world/Provider/activites_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ActivitesMonitorUsers extends StatefulWidget {
  const ActivitesMonitorUsers({super.key});

  @override
  State<ActivitesMonitorUsers> createState() => _ActivitesMonitorUsersState();
}

class _ActivitesMonitorUsersState extends State<ActivitesMonitorUsers> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final insActivites = Provider.of<Activites>(context);
    final activityList = insActivites.activites;
    return SizedBox(
      width: dw,
      height: 1000,
      child: Column(
        children: [
          loading == false
              ? ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 141, 26, 161)), fixedSize: MaterialStatePropertyAll(Size(240, 50))),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await insActivites.fetchCurrentUsers();
                    setState(() {
                      loading = false;
                    });
                  },
                  child: Text(
                    'Refresh',
                    style: GoogleFonts.signika(fontSize: 18),
                  ))
              : Lottie.asset('assets/animations/cube_loading_v2.json', width: 128),
          const SizedBox(height: 50),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: 500, crossAxisSpacing: 50, mainAxisSpacing: 50),
              itemCount: activityList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ActivityMontiorWidget(activity: activityList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
