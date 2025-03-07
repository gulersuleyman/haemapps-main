# Epi Extensions

Custom Dart and Flutter extensions

---

## Usage

Simply import the package and use it:
```dart
import 'package:epi_extensions/epi_extensions.dart';
```

## String extensions
```dart
'Epiwish'.hardcoded; // Epiwish 👷‍♂️
'epiwish'.capitalize; // Epiwish
'4294967295'.toColor; // Color(4294967295)
'hello'.repeat(3); // hellohellohello
'world'.prefix('hello '); // hello world
'hello'.suffix(' world'); // hello world
'7'.completeToTwoDigits; // 07
```
## Context extensions
```dart
// Get current theme
final ThemeData theme = context.theme;

// Check if the current theme is dark mode or light mode
final bool isDarkMode = context.isDarkMode;
final bool isLightMode = context.isLightMode;

// Create SizedBox with different sizes
final SizedBox tinyGap = context.tinyGap;
final SizedBox smallGap = context.smallGap;
final SizedBox mediumGap = context.mediumGap;
final SizedBox largeGap = context.largeGap;

// Create EdgeInsets.all with different sizes
final EdgeInsets smallPadding = context.smallPadding;
final EdgeInsets mediumPadding = context.mediumPadding;
final EdgeInsets largePadding = context.largePadding;

// Create EdgeInsets.symmetric(horizontal: size) with different sizes
final EdgeInsets smallHorizontalPadding = context.smallHorizontalPadding;
final EdgeInsets mediumHorizontalPadding = context.mediumHorizontalPadding;
final EdgeInsets largeHorizontalPadding = context.largeHorizontalPadding;

// Create EdgeInsets.symmetric(vertical: size) with different sizes
final EdgeInsets smallVerticalPadding = context.smallVerticalPadding;
final EdgeInsets mediumVerticalPadding = context.mediumVerticalPadding;
final EdgeInsets largeVerticalPadding = context.largeVerticalPadding;

// Get Screen Sizes
final double screenWidth = context.screenWidth;
final double screenHeight = context.screenHeight; 
```

## DateTime extensions
```dart
DateTime.now().timeAgo() // a moment ago
```