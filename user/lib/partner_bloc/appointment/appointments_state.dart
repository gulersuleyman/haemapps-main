part of 'appointments_bloc.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

final class AppointmentsLoading extends AppointmentsState {}

final class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  const AppointmentsLoaded(this.appointments);
}

final class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);
}

final class AppointmentsEmpty extends AppointmentsState {}
