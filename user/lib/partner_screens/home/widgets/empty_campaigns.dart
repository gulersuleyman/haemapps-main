import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user/partner_screens/create/create_campaign.dart';

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
              context.push(CreateCampaign.path);
            },
          ),
        ],
      ),
    );
  }
}
