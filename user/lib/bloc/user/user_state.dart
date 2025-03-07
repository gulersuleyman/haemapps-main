part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserLoaded extends UserState {
  final AppUser user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
