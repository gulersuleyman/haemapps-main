import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user/partner_screens/appointments/appointments_screen.dart';
import 'package:user/partner_screens/home/home_screen.dart';
import 'package:user/partner_screens/settings/settings_screen.dart';

part 'navigation_state.dart';

enum NavItem { home, appointments, settings }

class PartnerNavigationCubit extends Cubit<PartnerNavigationState> {
  PartnerNavigationCubit() : super(const PartnerNavigationState(NavItem.home, 0, PartnerHomeScreen()));

  void goTab(int index) {
    switch (index) {
      case 0:
        emit(const PartnerNavigationState(NavItem.home, 0, PartnerHomeScreen()));
      case 1:
        emit(const PartnerNavigationState(NavItem.appointments, 1, AppointmentsScreen()));
      case 2:
        emit(const PartnerNavigationState(NavItem.settings, 2, PartnerSettingsScreen()));
    }
  }
}
