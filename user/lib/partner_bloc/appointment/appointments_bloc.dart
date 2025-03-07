import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user/models/appointment.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  StreamSubscription? _subscription;

  AppointmentsBloc() : super(AppointmentsLoading()) {
    on<LoadAppointments>((event, emit) async {
      await _subscription?.cancel();

      final Stream<QuerySnapshot<Map<String, dynamic>>> reference =
          FirebaseFirestore.instance.collection('appointments').where('companyID', isEqualTo: event.userID).snapshots();

      final Stream<List<Appointment>> appointmentsStream =
          reference.map((snapshot) => snapshot.docs.map((doc) => Appointment.fromMap(doc.data(), doc.id)).toList());

      _subscription = appointmentsStream.listen(
        (appointments) {
          add(UpdateAppointments(appointments));
        },
        onError: (error) {
          add(AppointmentError(error.toString()));
        },
      );
    });
    on<UpdateAppointments>((event, emit) {
      if (event.appointments.isEmpty) {
        emit(const AppointmentsLoaded([]));
      } else {
        emit(AppointmentsLoaded(event.appointments));
      }
    });
    on<AppointmentError>((event, emit) {
      emit(AppointmentsError(event.message));
    });
  }
}
