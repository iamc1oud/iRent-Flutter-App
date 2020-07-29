import 'dart:io';

import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/providers/CardDetailProvider.dart';
import 'package:rent_app/screen/homescreen/home.dart';
import 'package:rent_app/screen/splash_screen.dart';
import 'package:rent_app/style.dart';

var _assetsToPreLoad = [AssetFlare(bundle: rootBundle, name: "assets/flare_animations/house.flr")];

Future<void> warmupFlare() async {
  for (final asset in _assetsToPreLoad) {
    await cachedActor(asset);
  }
}

main() async {
  // TODO: Implement shared preferences for theme settings
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.init(Directory.current.path);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  FlareCache.doesPrune = false;

  warmupFlare().then((value) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          snackBarTheme: SnackBarThemeData(backgroundColor: AppStyle().secondaryTextColor),
          primaryColor: Colors.indigo,
          secondaryHeaderColor: Colors.black),
      home: MultiProvider(
        providers: [
          Provider(
            create: (context) => UserDataProvider(),
          )
        ],
          child: SplashScreen()),
    );
  }
}
