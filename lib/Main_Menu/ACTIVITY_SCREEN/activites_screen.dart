import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: const Color.fromARGB(255, 20, 18, 26),
        child: const Center(
          child: Text(
            'Activites',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]);
  }
}
