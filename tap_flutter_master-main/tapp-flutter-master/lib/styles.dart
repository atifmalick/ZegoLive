import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';

class Styles {
  ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xff7257b3),
    scaffoldBackgroundColor: AppColors.background,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    fontFamily: 'Quicksand',
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffA288CE)),
  );
}

final Styles styles = Styles();
