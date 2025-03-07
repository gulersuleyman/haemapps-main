import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/partner_bloc/campaign/campaign_bloc.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_screens/home/widgets/campaign_card.dart';
import 'package:user/widgets/wave_dots.dart';

class CampaignsList extends StatelessWidget {
  const CampaignsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerCampaignBloc, CampaignState>(
      builder: (context, state) {
        if (state is Partner) {
          final Map<String, dynamic> geo = GetStorage().read('geo') ?? {};

          final campaigns = state.campaigns;
          return BlocBuilder<PartnerBloc, PartnerState>(
            builder: (context, state) {
              if (state is PartnerLoaded) {
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .7,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: campaigns
                      .map(
                        (campaign) => CampaignCard(
                          campaign: campaign,
                          geo: geo,
                          partner: state.partner,
                        ),
                      )
                      .toList(),
                );
              }

              return const Center(child: WaveDots());
            },
          );
        }

        return const Center(child: WaveDots());
      },
    );
  }
}
