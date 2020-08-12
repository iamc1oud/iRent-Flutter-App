import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool isLightTheme = true;

  ThemeProvider({
    this.isLightTheme
});

  toggleThemeData() async {
    final settings = await Hive.openBox("settings");
    settings.put('isLightTheme', !isLightTheme);
    isLightTheme = !isLightTheme;
    notifyListeners();
  }

  ThemeData themeData() {
    return ThemeData(
      primarySwatch: isLightTheme ? Colors.grey : Colors.grey,
      primaryColor: isLightTheme ? Colors.grey : Color(0xFF1E1F28),
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      accentColor: isLightTheme ? Color(0xFF26242e) : Color(0xFFFFFFFF),
      backgroundColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF26242e),
      floatingActionButtonTheme: isLightTheme ? FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white
      ):FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        elevation: 5,
        foregroundColor: Colors.black
      ),
      scaffoldBackgroundColor:
      isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF26242e),
    );
  }

  ThemeColor themeMode(){
    return ThemeColor(
      gradient: [
        if (isLightTheme) ...[Color(0xDDFF0080), Color(0xDDFF8C00)],
        if (!isLightTheme) ...[Color(0xFF8983F7), Color(0xFFA3DAFB)]
      ],
      textColor: isLightTheme ? Color(0xFF000000) : Color(0xFFFFFFFF),
      toggleButtonColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFf34323d),
      toggleBackgroundColor:
      isLightTheme ? Color(0xFFe7e7e8) : Color(0xFF222029),
      shadow: [
        if (isLightTheme)
          BoxShadow(
              color: Color(0xFFd8d7da),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5)),
        if (!isLightTheme)
          BoxShadow(
              //color: Color(0x66000000),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5))
      ],
    );
  }


}

class ThemeColor {
  List<Color> gradient;
  Color backgroundColor;
  Color toggleButtonColor;
  Color toggleBackgroundColor;
  Color textColor;
  List<BoxShadow> shadow;

  ThemeColor({
    this.gradient,
    this.backgroundColor,
    this.toggleBackgroundColor,
    this.toggleButtonColor,
    this.textColor,
    this.shadow,
  });
}
