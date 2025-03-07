part of 'appointment_post_bloc.dart';

sealed class AppointmentPostState extends Equatable {
  const AppointmentPostState();

  @override
  List<Object> get props => [];
}

final class AppointmentPostLoading extends AppointmentPostState {}

final class AppointmentPostLoaded extends AppointmentPostState {
  final List<AppointmentPost> appointmentPosts;

  const AppointmentPostLoaded(this.appointmentPosts);

  @override
  List<Object> get props => [appointmentPosts];
}

final class AppointmentPostGotError extends AppointmentPostState {
  final String message;

  const AppointmentPostGotError(this.message);
}

final class AppointmentPostEmpty extends AppointmentPostState {}
