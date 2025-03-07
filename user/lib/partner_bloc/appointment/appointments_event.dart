part of 'appointments_bloc.dart';

sealed class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

final class LoadAppointments extends AppointmentsEvent {
  final String userID;

  const LoadAppointments({required this.userID});
}

final class UpdateAppointments extends AppointmentsEvent {
  final List<Appointment> appointments;

  const UpdateAppointments(this.appointments);
}

final class AppointmentError extends AppointmentsEvent {
  final String message;

  const AppointmentError(this.message);
}
