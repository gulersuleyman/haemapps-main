import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/cubit/navigation/navigation_cubit.dart';

class UserAppNavigationBar extends StatelessWidget {
  const UserAppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    final String logo = 'assets/logo_${isDark ? 'white' : 'black'}.png';

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.index,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => context.read<NavigationCubit>().goTab(index),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    context.theme.colorScheme.onSurface.withOpacity(.3),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    logo,
                    width: 34,
                    height: 34,
                  ),
                ),
              ),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  logo,
                  width: 34,
                  height: 34,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Appointments',
              icon: Icon(
                Icons.calendar_month,
                color: context.theme.colorScheme.onSurface.withOpacity(.3),
              ),
              activeIcon: Icon(
                Icons.calendar_month,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(
                Icons.person,
                color: context.theme.colorScheme.onSurface.withOpacity(.3),
              ),
              activeIcon: Icon(
                Icons.person,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}
