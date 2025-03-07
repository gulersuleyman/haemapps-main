part of 'campaign_bloc.dart';

sealed class CampaignState extends Equatable {
  const CampaignState();

  @override
  List<Object> get props => [];
}

final class CampaignsLoading extends CampaignState {}

final class CampaignsLoaded extends CampaignState {
  final List<Campaign> campaigns;

  const CampaignsLoaded(this.campaigns);

  @override
  List<Object> get props => [campaigns];
}

final class CampaignsError extends CampaignState {
  final String message;

  const CampaignsError(this.message);

  @override
  List<Object> get props => [message];
}

final class CampaignsEmpty extends CampaignState {}
