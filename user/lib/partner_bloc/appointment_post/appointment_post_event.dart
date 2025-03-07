part of 'appointment_post_bloc.dart';

sealed class AppointmentPostEvent extends Equatable {
  const AppointmentPostEvent();

  @override
  List<Object> get props => [];
}

final class LoadAppointmentPost extends AppointmentPostEvent {
  final String userID;

  const LoadAppointmentPost({required this.userID});

  @override
  List<Object> get props => [userID];
}

final class UpdateAppointmentPost extends AppointmentPostEvent {
  final List<AppointmentPost> appointmentPosts;

  const UpdateAppointmentPost(this.appointmentPosts);

  @override
  List<Object> get props => [appointmentPosts];
}

final class AppointmentPostError extends AppointmentPostEvent {
  final String message;

  const AppointmentPostError(this.message);

  @override
  List<Object> get props => [message];
}
