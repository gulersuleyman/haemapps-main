part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final NavItem item;
  final int index;
  final Widget screen;

  const NavigationState(this.item, this.index, this.screen);

  @override
  List<Object> get props => [item, index, screen];
}
