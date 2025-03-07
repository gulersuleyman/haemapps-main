part of 'partner_bloc.dart';

sealed class PartnerState extends Equatable {
  const PartnerState();

  @override
  List<Object> get props => [];
}

final class PartnerLoading extends PartnerState {
  const PartnerLoading();
}

final class PartnerLoaded extends PartnerState {
  final PartnerUser partner;

  const PartnerLoaded(this.partner);

  @override
  List<Object> get props => [partner];
}

final class PartnerError extends PartnerState {
  final String message;

  const PartnerError(this.message);

  @override
  List<Object> get props => [message];
}
