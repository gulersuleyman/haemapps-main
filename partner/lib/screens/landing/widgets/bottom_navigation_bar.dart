import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner/cubit/navigation/navigation_cubit.dart';

class PartnerAppNavigationBar extends StatelessWidget {
  const PartnerAppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(
                Icons.home,
                color: context.theme.colorScheme.onSurface.withOpacity(.3),
              ),
              activeIcon: Icon(
                Icons.home,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                Icons.settings,
                color: context.theme.colorScheme.onSurface.withOpacity(.3),
              ),
              activeIcon: Icon(
                Icons.settings,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }
}
