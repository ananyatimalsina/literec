import 'package:flutter/material.dart';
import 'package:literec/screens/splash_screen.dart';
import 'package:literec/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

String recPath = "";
String encoder = "AAC";
// ignore: prefer_typing_uninitialized_variables
var prefs;

final BannerAd mainBanner = BannerAd(
  adUnitId: 'ca-app-pub-8969481346708013/3936071507',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

final BannerAd secondaryBanner = BannerAd(
  adUnitId: 'ca-app-pub-8969481346708013/7773096935',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

final AdWidget adWidget = AdWidget(ad: mainBanner);

final AdWidget adWidget2 = AdWidget(ad: secondaryBanner);

final Container adContainer = Container(
  alignment: Alignment.bottomCenter,
  child: adWidget,
  width: mainBanner.size.width.toDouble(),
  height: mainBanner.size.height.toDouble(),
);

final Container adContainer2 = Container(
  alignment: Alignment.bottomCenter,
  child: adWidget2,
  width: mainBanner.size.width.toDouble(),
  height: mainBanner.size.height.toDouble(),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const LiteRec());
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
    mainBanner.load();
    secondaryBanner.load();
    prefs = await SharedPreferences.getInstance();
    recPath = prefs.getString("recPath");
    encoder = prefs.getString("encoder");
  }
}

class InitializationApp extends StatelessWidget {
  InitializationApp({Key? key}) : super(key: key);

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

class LiteRec extends StatelessWidget {
  const LiteRec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LiteRec",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: InitializationApp(),
    );
  }
}
