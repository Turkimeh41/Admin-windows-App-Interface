import 'package:flutter/material.dart';
import 'package:hello_world/Custom/desktop_scrollbehavior.dart';
import 'package:hello_world/Handler/keyboard_handler.dart';
import 'package:hello_world/Provider/anonymous_provider.dart';
import 'package:hello_world/Provider/managers_provider.dart';
import 'package:hello_world/SETTINGS/settings_screen.dart';
import 'package:hello_world/admin_provider.dart';
import 'package:hello_world/data_container.dart';
import './Provider/activites_provider.dart';
import 'package:hello_world/Provider/users_provider.dart';
import 'LOGIN_SCREEN/login_screen.dart';
import 'package:hello_world/round_corners.dart';
import 'package:window_manager/window_manager.dart';
import 'Handler/Window_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Keyboard.initilize();
  await WindowHandler.setWindow(initSize: const Size(1280, 968), minSize: const Size(560, 468), maxSize: const Size(1680, 1122));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Admin(),
        ),
        ChangeNotifierProxyProvider<Admin, Managers>(
          create: (context) => Managers(),
          update: (context, admin, managers) {
            return managers!..adminUpdate(admin.idToken, admin.docID);
          },
        ),
        ChangeNotifierProxyProvider<Admin, Users>(
          create: (context) => Users(),
          update: (context, admin, users) {
            Keyboard.idToken = admin.idToken;
            Keyboard.refreshToken = admin.refreshToken;
            return users!..adminUpdate(admin.idToken, admin.docID);
          },
        ),
        ChangeNotifierProxyProvider<Admin, Activites>(
          create: (context) => Activites(),
          update: (context, admin, activites) => activites!..adminUpdate(admin.idToken, admin.docID),
        ),
        ChangeNotifierProxyProvider<Admin, AnonymousUsers>(
          create: (context) => AnonymousUsers(),
          update: (context, admin, anonymousUsers) => anonymousUsers!..adminUpdate(admin.idToken, admin.docID),
        ),
      ],
      builder: (context, child) => MaterialApp(
          scrollBehavior: DesktopScrollBehavior(),
          theme: ThemeData(
              brightness: Brightness.dark,
              dividerColor: const Color.fromARGB(255, 71, 71, 92),
              textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white, selectionHandleColor: Colors.white)),
          routes: {
            SettingScreen.routename: (context) => const SettingScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
            DataContainer.routeName: (_) => const DataContainer(),
          },
          debugShowCheckedModeBanner: false,
          color: Colors.transparent,
          builder: (context, child) => RoundWidget.initWindowCorner(
                tabbarColor: const Color.fromARGB(255, 4, 4, 15),
                child: child,
                context: context,
                windowCaptionColor: const Color.fromARGB(255, 4, 4, 15),
                brightness: Brightness.dark,
              ),
          title: 'Adminstrator',
          home: const LoginScreen()),
    );
  }
}
