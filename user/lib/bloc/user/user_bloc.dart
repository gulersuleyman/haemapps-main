import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  StreamSubscription? _subscription;

  UserBloc() : super(const UserLoading()) {
    on<LoadUser>((event, emit) async {
      await _subscription?.cancel();

      final Stream<AppUser> userStream =
          FirebaseFirestore.instance.collection('users').doc(event.userID).snapshots().map((snapshot) => AppUser.fromMap(snapshot.data()!, snapshot.id));

      _subscription = userStream.listen(
        (user) {
          add(UpdateUser(user));
        },
        onError: (error) {
          add(UpdateUser(AppUser(id: event.userID, email: 'error', favorites: const [])));
        },
      );
    });
    on<UpdateUser>((event, emit) {
      log('✅ User Updated || ${event.user}');
      emit(UserLoaded(event.user));
    });
    on<Error>((event, emit) {
      log('❌ User Error || ${event.message}');
      emit(UserError(event.message));
    });
  }
}
