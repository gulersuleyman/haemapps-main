import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:models/models.dart';

part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  StreamSubscription? _subscription;

  CampaignBloc() : super(CampaignsLoading()) {
    on<LoadCampaigns>((event, emit) async {
      if (event.geo.isEmpty) {
        emit(const CampaignsError('Geo is empty'));
        return;
      }

      await _subscription?.cancel();

      const double radius = 3;
      final double lat = event.geo['lat'];
      final double lon = event.geo['lon'];

      final CollectionReference<Campaign> reference = FirebaseFirestore.instance.collection('campaigns').withConverter(
            fromFirestore: (snapshot, _) => Campaign.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (campaign, _) => campaign.toMap(),
          );

      GeoPoint geopointFrom(Campaign data) => data.geo['geopoint'] as GeoPoint;

      final Stream<List<Campaign>> campaignsStream = GeoCollectionReference<Campaign>(reference)
          .subscribeWithin(
        center: GeoFirePoint(GeoPoint(lat, lon)),
        radiusInKm: radius,
        field: 'geo',
        geopointFrom: geopointFrom,
      )
          .map((snapshotList) {
        final now = Timestamp.now();
        return snapshotList.map((snapshot) => snapshot.data()!).where((campaign) {
          final endTimestamp = campaign.end as Timestamp?;
          return endTimestamp == null || endTimestamp.compareTo(now) >= 0;
        }).toList();
      });

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
      log('❌ Campaigns Error || ${event.message}');
      emit(CampaignsError(event.message));
    });
  }
}
