import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user/models/appointment_post.dart';

part 'appointment_post_event.dart';
part 'appointment_post_state.dart';

class AppointmentPostBloc extends Bloc<AppointmentPostEvent, AppointmentPostState> {
  StreamSubscription? _subscription;

  AppointmentPostBloc() : super(AppointmentPostLoading()) {
    on<LoadAppointmentPost>((event, emit) async {
      await _subscription?.cancel();

      final Stream<QuerySnapshot<Map<String, dynamic>>> reference =
          FirebaseFirestore.instance.collection('appointmentPosts').where('companyID', isEqualTo: event.userID).snapshots();

      final Stream<List<AppointmentPost>> appointmentPostsStream =
          reference.map((snapshot) => snapshot.docs.map((doc) => AppointmentPost.fromMap(doc.data(), doc.id)).toList());

      _subscription = appointmentPostsStream.listen(
        (appointmentPosts) {
          add(UpdateAppointmentPost(appointmentPosts));
        },
      );
    });
    on<UpdateAppointmentPost>((event, emit) {
      if (event.appointmentPosts.isEmpty) {
        emit(const AppointmentPostLoaded([]));
      } else {
        emit(AppointmentPostLoaded(event.appointmentPosts));
      }
    });
    on<AppointmentPostError>((event, emit) {
      emit(AppointmentPostGotError(event.message));
    });
  }
}
