import 'package:flutter/material.dart';
import 'package:openrec/screens/splash_screen.dart';
import 'package:openrec/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

String recPath = "";
String encoder = "AAC";

// ignore: prefer_typing_uninitialized_variables
var prefs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OpenRec());
}

class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    await [
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  static _loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    recPath = prefs.getString("recPath");
    encoder = prefs.getString("encoder");
  }
}

class InitializationApp extends StatelessWidget {
  InitializationApp({super.key});

  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Home();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

class OpenRec extends StatelessWidget {
  const OpenRec({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenRec",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: InitializationApp(),
    );
  }
}
