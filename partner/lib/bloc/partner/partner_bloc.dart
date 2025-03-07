import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'partner_event.dart';
part 'partner_state.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  StreamSubscription? _subscription;

  PartnerBloc() : super(const PartnerLoading()) {
    on<LoadPartner>((event, emit) async {
      await _subscription?.cancel();

      final Stream<PartnerUser> partnerStream =
          FirebaseFirestore.instance.collection('partners').doc(event.userID).snapshots().map((snapshot) => PartnerUser.fromMap(snapshot.data()!, snapshot.id));

      _subscription = partnerStream.listen(
        (partner) {
          add(UpdatePartner(partner));
        },
        onError: (error) {
          add(Error(error.toString()));
        },
      );
    });
    on<UpdatePartner>((event, emit) {
      log('✅ Partner Updated || ${event.partner}');
      emit(PartnerLoaded(event.partner));
    });
    on<Error>((event, emit) {
      log('❌ Partner Error || ${event.message}');
      emit(PartnerError(event.message));
    });
  }
}
