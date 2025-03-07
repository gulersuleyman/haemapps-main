import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:partner/create/create_campaign.dart';
import 'package:partner/screens/premium/premium_screen.dart';

class EmptyCampaigns extends StatelessWidget {
  const EmptyCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💭'),
          const Text('Aktif kampanya bulunamadı.'),
          context.smallGap,
          ElevatedButton(
            child: const Text('Şimdi Oluştur'),
            onPressed: () {
              final bool isPro = EpiFirebaseAuth.instance.currentUser?.displayName == 'pro';
              // if (isPro) {
              context.push(CreateCampaign.path);
              // } else {
              // context.push(PremiumScreen.path);
              // }
            },
          ),
        ],
      ),
    );
  }
}
