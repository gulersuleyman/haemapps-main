part of 'partner_bloc.dart';

sealed class PartnerEvent extends Equatable {
  const PartnerEvent();

  @override
  List<Object> get props => [];
}

final class LoadPartner extends PartnerEvent {
  final String userID;

  const LoadPartner({required this.userID});

  @override
  List<Object> get props => [userID];
}

final class UpdatePartner extends PartnerEvent {
  final PartnerUser partner;

  const UpdatePartner(this.partner);

  @override
  List<Object> get props => [partner];
}

final class Error extends PartnerEvent {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}
