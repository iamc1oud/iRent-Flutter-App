import 'dart:io';

import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/providers/theme_provider.dart';
import 'package:rent_app/screen/splash_screen.dart';

var _assetsToPreLoad = [AssetFlare(bundle: rootBundle, name: "assets/flare_animations/house.flr")];

Future<void> warmupFlare() async {
  for (final asset in _assetsToPreLoad) {
    await cachedActor(asset);
  }
}

Future<void> main() async {
  // Initializing [WidgetsFlutterBinding]
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization of [Hive]
  Directory appDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  final settings = await Hive.openBox("settings");

  // If [isLightTheme] is null set to false
  bool isLightTheme = settings.get("isLightTheme") ?? false;
  print("Light theme enabled: " + isLightTheme.toString());

  // Removing the status bar display
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  FlareCache.doesPrune = false;

  warmupFlare().then((value) => runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(isLightTheme : isLightTheme),
      )
    ],
      child: AppStart())));
}

class AppStart extends StatelessWidget {
  const AppStart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return App(
      themeProvider: themeProvider,
    );
  }
}


class App extends StatefulWidget {
  final ThemeProvider themeProvider;

  const App({Key key, @required this.themeProvider}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: widget.themeProvider.themeData(),
        home: SplashScreen(),
    );
  }
}