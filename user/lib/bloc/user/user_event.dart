part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class LoadUser extends UserEvent {
  final String userID;

  const LoadUser({required this.userID});

  @override
  List<Object> get props => [userID];
}

final class UpdateUser extends UserEvent {
  final AppUser user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

final class Error extends UserEvent {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}
