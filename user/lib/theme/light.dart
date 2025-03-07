import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primarycolor = Color(0xff0F502E);
const Color secondaryColor = Color(0xffA6F7CC);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primarycolor,
    primary: primarycolor,
    secondary: secondaryColor,
    shadow: Colors.black.withOpacity(.1),
    scrim: Colors.white,
  ),
  appBarTheme: lightAppBarTheme,
  bottomNavigationBarTheme: lightBottomNavigationBarTheme,
  textTheme: lightTextTheme,
);

const AppBarTheme lightAppBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
);
const BottomNavigationBarThemeData lightBottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Colors.white,
);

TextTheme lightTextTheme = GoogleFonts.robotoTextTheme(
  ThemeData.light().textTheme.copyWith(
        labelSmall: ThemeData.light().textTheme.labelSmall!.copyWith(
              color: Colors.grey,
            ),
        labelLarge: ThemeData.light().textTheme.labelLarge!.copyWith(
              color: Colors.grey,
            ),
        labelMedium: ThemeData.light().textTheme.labelMedium!.copyWith(
              color: Colors.grey,
            ),
      ),
);
