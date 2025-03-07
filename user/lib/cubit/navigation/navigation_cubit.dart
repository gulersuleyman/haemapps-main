import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user/screens/appointmentPosts/appointment_posts_screen.dart';
import 'package:user/screens/home/home_screen.dart';
import 'package:user/screens/profile/profile_screen.dart';

part 'navigation_state.dart';

enum NavItem { home, appointments, profile }

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavItem.home, 0, HomeScreen()));

  void goTab(int index) {
    switch (index) {
      case 0:
        emit(const NavigationState(NavItem.home, 0, HomeScreen()));
      case 1:
        emit(const NavigationState(NavItem.appointments, 1, AppointmentPostsScreen()));
      case 2:
        emit(const NavigationState(NavItem.profile, 2, ProfileScreen()));
    }
  }
}
