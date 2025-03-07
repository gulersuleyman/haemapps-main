part of 'appointment_posts_bloc.dart';

sealed class AppointmentPostsEvent extends Equatable {
  const AppointmentPostsEvent();

  @override
  List<Object> get props => [];
}

final class LoadAppointmentPosts extends AppointmentPostsEvent {
  final Map<String, dynamic> geo;

  const LoadAppointmentPosts({required this.geo});

  @override
  List<Object> get props => [geo];
}

final class UpdateAppointmentPosts extends AppointmentPostsEvent {
  final List<AppointmentPost> appointmentPosts;

  const UpdateAppointmentPosts(this.appointmentPosts);

  @override
  List<Object> get props => [appointmentPosts];
}

final class Error extends AppointmentPostsEvent {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}
