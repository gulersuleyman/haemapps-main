part of 'appointment_posts_bloc.dart';

sealed class AppointmentPostsState extends Equatable {
  const AppointmentPostsState();

  @override
  List<Object> get props => [];
}

final class AppointmentPostsLoading extends AppointmentPostsState {}

final class AppointmentPostsLoaded extends AppointmentPostsState {
  final List<AppointmentPost> appointmentPosts;

  const AppointmentPostsLoaded(this.appointmentPosts);
}

final class AppointmentPostsError extends AppointmentPostsState {
  final String message;

  const AppointmentPostsError(this.message);
}
