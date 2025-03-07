import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/widgets/wave_dots.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, state) {
          if (state is PartnerLoaded) {
            final PartnerUser partner = state.partner;
            return ListView(
              children: [
                ListTile(
                  title: const Text('İşletme Adı:'),
                  subtitle: Text(partner.name),
                ),
              ],
            );
          }

          return const Center(child: WaveDots());
        },
      ),
    );
  }
}
