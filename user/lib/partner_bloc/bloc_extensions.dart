import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';

extension BlocExtensions on BuildContext {
  PartnerUser? get getPartnerUser {
    final PartnerBloc bloc = BlocProvider.of<PartnerBloc>(this);
    final PartnerState state = bloc.state;

    if (state is PartnerLoaded) {
      return state.partner;
    } else {
      return null;
    }
  }
}
