part of 'campaign_bloc.dart';

sealed class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object> get props => [];
}

final class LoadCampaigns extends CampaignEvent {
  final Map<String, dynamic> geo;

  const LoadCampaigns({required this.geo});

  @override
  List<Object> get props => [geo];
}

final class UpdateCampaigns extends CampaignEvent {
  final List<Campaign> campaigns;

  const UpdateCampaigns(this.campaigns);

  @override
  List<Object> get props => [campaigns];
}

final class Error extends CampaignEvent {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}
