import 'package:ai_blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // by adding _ before the variable name, it becomes private(we can't access it outside the class)
  // what is static variable? static varibale are those which can directly be accessed by the class name without creating an object of the class
  // what is final variable? final variable are those which can be assigned only once and after that they can't be changed
  // what is const variable? const variable are those which are compile time constant and can't be changed at runtime


  // below is function which take color as an argument and return OutlineInputBorder widget  and if the color is not provided then it will take AppPallete.borderColor as default color
  static _border([Color color = AppPallete.borderColor]) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
    ),
    chipTheme: const ChipThemeData(
      color: MaterialStatePropertyAll(
        AppPallete.backgroundColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
    ),
  );

}
