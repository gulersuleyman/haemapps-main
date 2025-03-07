import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  StreamSubscription? _subscription;

  CampaignBloc() : super(CampaignsLoading()) {
    on<LoadCampaigns>((event, emit) async {
      await _subscription?.cancel();

      final Stream<QuerySnapshot<Map<String, dynamic>>> reference =
          FirebaseFirestore.instance.collection('campaigns').where('companyID', isEqualTo: event.userID).snapshots();

      final Stream<List<Campaign>> campaignsStream = reference.map((snapshot) => snapshot.docs.map((doc) => Campaign.fromMap(doc.data(), doc.id)).toList());

      _subscription = campaignsStream.listen(
        (campaigns) {
          add(UpdateCampaigns(campaigns));
        },
        onError: (error) {
          add(Error(error.toString()));
        },
      );
    });
    on<UpdateCampaigns>((event, emit) {
      if (event.campaigns.isEmpty) {
        log('✅ Campaigns Updated || 0 campaigns found');
        emit(const CampaignsLoaded([]));
      } else {
        log('✅ Campaigns Updated || ${event.campaigns.length} campaigns found');
        emit(CampaignsLoaded(event.campaigns));
      }
    });
    on<Error>((event, emit) {
      emit(CampaignsError(event.message));
    });
  }
}
