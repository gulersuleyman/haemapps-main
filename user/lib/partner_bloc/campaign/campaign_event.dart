part of 'campaign_bloc.dart';

sealed class PartnerCampaignEvent extends Equatable {
  const PartnerCampaignEvent();

  @override
  List<Object> get props => [];
}

final class LoadPartnerCampaigns extends PartnerCampaignEvent {
  final String userID;

  const LoadPartnerCampaigns({required this.userID});

  @override
  List<Object> get props => [userID];
}

final class UpdatePartnerCampaigns extends PartnerCampaignEvent {
  final List<Campaign> campaigns;

  const UpdatePartnerCampaigns(this.campaigns);

  @override
  List<Object> get props => [campaigns];
}

final class PartnerError extends PartnerCampaignEvent {
  final String message;

  const PartnerError(this.message);

  @override
  List<Object> get props => [message];
}
