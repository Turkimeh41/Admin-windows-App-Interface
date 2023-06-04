import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'package:provider/provider.dart';

class PieChartUserAnony extends StatefulWidget {
  const PieChartUserAnony({super.key});

  @override
  State<PieChartUserAnony> createState() => _PieChartUserAnonyState();
}

class _PieChartUserAnonyState extends State<PieChartUserAnony> {
  int touchedIndex = -1;
  late AnonymousUsers insAnonymousUsers;
  late Users insUsers;

  @override
  void initState() {
    insAnonymousUsers = Provider.of<AnonymousUsers>(context, listen: false);
    insUsers = Provider.of<Users>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 400,
        width: 400,
        child: PieChart(PieChartData(
          borderData: FlBorderData(show: true, border: Border.all(width: 15, color: Colors.red)),
          centerSpaceRadius: 0,
          sectionsSpace: 4,
          sections: showingSections(),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
        )),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        double precentage = getPrecentage(i);
        switch (i) {
          case 0:
            return PieChartSectionData(
              titleStyle: GoogleFonts.signika(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              color: Colors.purple,
              value: precentage,
              title: '${precentage.toStringAsFixed(1)}% Normal Users',
              radius: 200,
              borderSide: isTouched ? const BorderSide(color: Color.fromARGB(255, 115, 16, 133), width: 6) : BorderSide(color: Colors.blue.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              titleStyle: GoogleFonts.signika(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              color: Colors.green,
              value: precentage,
              title: '${precentage.toStringAsFixed(1)}% Anonymous Users',
              radius: 200,
              borderSide: isTouched ? const BorderSide(color: Color.fromARGB(255, 19, 87, 21), width: 6) : BorderSide(color: Colors.white.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }

  double getPrecentage(int index) {
    int totalAllUsers = insAnonymousUsers.assignedAnonymousQRcodes + insUsers.users.length;
    late double precentage;
    switch (index) {
      case 0:
        precentage = insUsers.users.length / totalAllUsers * 100;

        break;
      case 1:
        precentage = insAnonymousUsers.assignedAnonymousQRcodes / totalAllUsers * 100;
        break;
    }
    return precentage;
  }
}
