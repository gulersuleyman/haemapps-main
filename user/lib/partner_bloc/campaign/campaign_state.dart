part of 'campaign_bloc.dart';

sealed class CampaignState extends Equatable {
  const CampaignState();

  @override
  List<Object> get props => [];
}

final class PartnerCampaignsLoading extends CampaignState {}

final class Partner extends CampaignState {
  final List<Campaign> campaigns;

  const Partner(this.campaigns);

  @override
  List<Object> get props => [campaigns];
}

final class PartnerCampaignsError extends CampaignState {
  final String message;

  const PartnerCampaignsError(this.message);

  @override
  List<Object> get props => [message];
}

final class PartnerCampaignsEmpty extends CampaignState {}
