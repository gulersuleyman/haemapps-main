import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;
  SizedBox get tinyGap => const SizedBox(height: 5, width: 5);
  SizedBox get smallGap => const SizedBox(height: 10, width: 10);
  SizedBox get mediumGap => const SizedBox(height: 20, width: 20);
  SizedBox get largeGap => const SizedBox(height: 30, width: 30);
  EdgeInsets get smallPadding => const EdgeInsets.all(8);
  EdgeInsets get mediumPadding => const EdgeInsets.all(12);
  EdgeInsets get largePadding => const EdgeInsets.all(18);
  EdgeInsets get smallHorizontalPadding => const EdgeInsets.symmetric(horizontal: 8);
  EdgeInsets get mediumHorizontalPadding => const EdgeInsets.symmetric(horizontal: 12);
  EdgeInsets get largeHorizontalPadding => const EdgeInsets.symmetric(horizontal: 18);
  EdgeInsets get smallVerticalPadding => const EdgeInsets.symmetric(vertical: 8);
  EdgeInsets get mediumVerticalPadding => const EdgeInsets.symmetric(vertical: 12);
  EdgeInsets get largeVerticalPadding => const EdgeInsets.symmetric(vertical: 18);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
