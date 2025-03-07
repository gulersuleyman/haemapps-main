part of 'navigation_cubit.dart';

class PartnerNavigationState extends Equatable {
  final NavItem item;
  final int index;
  final Widget screen;

  const PartnerNavigationState(this.item, this.index, this.screen);

  @override
  List<Object> get props => [item, index, screen];
}
