import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:partner/screens/settings/settings_screen.dart';
import 'package:partner/screens/home/home_screen.dart';

part 'navigation_state.dart';

enum NavItem { home, settings }

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavItem.home, 0, HomeScreen()));

  void goTab(int index) {
    switch (index) {
      case 0:
        emit(const NavigationState(NavItem.home, 0, HomeScreen()));
      case 1:
        emit(const NavigationState(NavItem.settings, 1, SettingsScreen()));
    }
  }
}
