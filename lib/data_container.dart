import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:hello_world/admin_provider.dart';
import './Main_Menu/TAB_SCREEN/tab_screen.dart';

import 'package:hello_world/Provider/activites_provider.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class DataContainer extends StatefulWidget {
  static String routeName = '/DataContainer';

  const DataContainer({super.key});

  @override
  State<DataContainer> createState() => _DataContainerState();
}

class _DataContainerState extends State<DataContainer> {
  Future<void> fetchData(BuildContext context) async {
    final admin = Provider.of<Admin>(context, listen: false);
    final activity = Provider.of<Activites>(context, listen: false);
    final manager = Provider.of<Managers>(context, listen: false);
    final user = Provider.of<Users>(context, listen: false);
    final anonymous = Provider.of<AnonymousUsers>(context, listen: false);
    await Future.wait([user.fetchUsers(), activity.fetchActivites(), manager.fetchManagers(), anonymous.fetchAnonymousUsers()]);
    Timer(const Duration(hours: 1), () {
      admin.refreshNewToken();
    });
    log('setting windows...');
    await windowManager.setSize(const Size(1956, 1256));
    await windowManager.setMinimumSize(const Size(1400, 1024));
    await windowManager.setMaximumSize(const Size(2342, 1290));
    log('done...');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const TabScreen();
          } else {
            return Container(
                color: const Color.fromARGB(255, 20, 18, 26),
                child: const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Color.fromARGB(255, 87, 14, 26),
                )));
          }
        });
  }
}
