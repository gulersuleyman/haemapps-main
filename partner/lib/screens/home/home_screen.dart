import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:partner/bloc/campaign/campaign_bloc.dart';
import 'package:partner/bloc/partner/partner_bloc.dart';
import 'package:partner/create/create_campaign.dart';
import 'package:partner/screens/home/widgets/campaigns_list.dart';
import 'package:partner/screens/home/widgets/empty_campaigns.dart';
import 'package:partner/screens/settings/screens/edit_profile_screen.dart';
import 'package:partner/widgets/wave_dots.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanyalarım'),
      ),
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, partnerState) {
          if (partnerState is PartnerLoaded) {
            return BlocBuilder<CampaignBloc, CampaignState>(
              builder: (context, state) {
                if (state is CampaignsLoaded) {
                  final List<Campaign> campaigns = state.campaigns;

                  if (campaigns.isEmpty) {
                    return const EmptyCampaigns();
                  }

                  return ListView(
                    padding: context.mediumPadding,
                    children: [
                      if (partnerState.partner.imageUrl == null) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  partner: partnerState.partner,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                context.smallGap,
                                Icon(Icons.lightbulb_rounded, color: context.theme.colorScheme.onSecondary),
                                const Spacer(),
                                Text(
                                  'Başlamadan önce profil bilgilerinizi dolurun',
                                  style: TextStyle(color: context.theme.colorScheme.onSecondary),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: context.theme.colorScheme.onSecondary,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        context.mediumGap,
                      ],
                      ElevatedButton(
                        child: const Text('Yeni Kampanya Oluştur'),
                        onPressed: () {
                          // final bool isPro = EpiFirebaseAuth.instance.currentUser?.displayName == 'pro';
                          // if (isPro) {
                          context.push(CreateCampaign.path);
                          // } else {
                          //   context.push(PremiumScreen.path);
                          // }
                        },
                      ),
                      context.mediumGap,
                      const CampaignsList(),
                    ],
                  );
                }

                if (state is CampaignsError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return const Center(
                  child: WaveDots(),
                );
              },
            );
          }

          return const Center(
            child: WaveDots(),
          );
        },
      ),
    );
  }
}
