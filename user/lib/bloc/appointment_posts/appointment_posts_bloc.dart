import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:user/models/appointment_post.dart';

part 'appointment_posts_event.dart';
part 'appointment_posts_state.dart';

class AppointmentPostsBloc extends Bloc<AppointmentPostsEvent, AppointmentPostsState> {
  StreamSubscription? _subscription;

  AppointmentPostsBloc() : super(AppointmentPostsLoading()) {
    on<LoadAppointmentPosts>((event, emit) async {
      if (event.geo.isEmpty) {
        emit(const AppointmentPostsError('Geo is empty'));
        return;
      }

      await _subscription?.cancel();

      final CollectionReference<AppointmentPost> reference = FirebaseFirestore.instance.collection('appointmentPosts').withConverter(
            fromFirestore: (snapshot, _) => AppointmentPost.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (appointmentPost, _) => appointmentPost.toMap(),
          );

      GeoPoint geopointFrom(AppointmentPost data) => data.geo['geopoint'] as GeoPoint;

      const double radius = 3;
      final double lat = event.geo['lat'];
      final double lon = event.geo['lon'];

      final Stream<List<AppointmentPost>> appointmentPostsStream = GeoCollectionReference<AppointmentPost>(reference)
          .subscribeWithin(
        center: GeoFirePoint(GeoPoint(lat, lon)),
        radiusInKm: radius,
        field: 'geo',
        geopointFrom: geopointFrom,
      )
          .map((snapshotList) {
        return snapshotList.map((snapshot) => snapshot.data()!).toList();
      });

      _subscription = appointmentPostsStream.listen(
        (appointmentPosts) {
          add(UpdateAppointmentPosts(appointmentPosts));
        },
        onError: (error) {
          add(Error(error.toString()));
        },
      );
    });
    on<UpdateAppointmentPosts>((event, emit) {
      emit(AppointmentPostsLoaded(event.appointmentPosts));
    });
    on<Error>((event, emit) {
      emit(AppointmentPostsError(event.message));
    });
  }
}
