part of 'campaign_bloc.dart';

sealed class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object> get props => [];
}

final class LoadCampaigns extends CampaignEvent {
  final String userID;

  const LoadCampaigns({required this.userID});

  @override
  List<Object> get props => [userID];
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
