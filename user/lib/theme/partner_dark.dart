import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primarycolor = Color(0xffFF9100);

ThemeData partnerDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primarycolor,
    primary: primarycolor,
    shadow: Colors.black.withOpacity(.15),
    surface: const Color(0xff1E1E1E),
  ),
  textTheme: darkTextTheme,
  appBarTheme: darkAppBarTheme,
  bottomNavigationBarTheme: darkBottomNavigationBarTheme,
  scaffoldBackgroundColor: const Color(0xff121212),
);

const AppBarTheme darkAppBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
);
const BottomNavigationBarThemeData darkBottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Color(0xff1E1E1E),
);

TextTheme darkTextTheme = GoogleFonts.robotoTextTheme(
  ThemeData.dark().textTheme.copyWith(
        labelSmall: ThemeData.dark().textTheme.labelSmall!.copyWith(
              color: const Color(0xff95A5A6),
            ),
        labelLarge: ThemeData.dark().textTheme.labelLarge!.copyWith(
              color: const Color(0xff95A5A6),
            ),
        labelMedium: ThemeData.dark().textTheme.labelMedium!.copyWith(
              color: const Color(0xff95A5A6),
            ),
      ),
);
