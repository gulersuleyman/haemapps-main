import 'package:flutter/material.dart';

extension Hardcoded on String {
  String get hardcoded => '$this 👷‍♂️';
}

extension Capitalize on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}

extension ToColor on String {
  Color get toColor => Color(int.parse(this));
}

extension Repeat on String {
  String repeat(int times) {
    return List.filled(times, this).join();
  }
}

extension Prefix on String {
  String prefix(String prefix) => '$prefix$this';
}

extension Suffix on String {
  String suffix(String suffix) => '$this$suffix';
}

extension CompleteToTwoDigits on String {
  String get completeToTwoDigits => padLeft(2, '0');
}
