import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:user/partner_bloc/campaign/campaign_bloc.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_screens/create/create_campaign.dart';
import 'package:user/partner_screens/home/widgets/campaigns_list.dart';
import 'package:user/partner_screens/home/widgets/empty_campaigns.dart';
import 'package:user/partner_screens/settings/screens/edit_profile_screen.dart';
import 'package:user/widgets/wave_dots.dart';

class PartnerHomeScreen extends StatelessWidget {
  const PartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanyalarım'),
      ),
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, partnerState) {
          if (partnerState is PartnerLoaded) {
            return BlocBuilder<PartnerCampaignBloc, CampaignState>(
              builder: (context, state) {
                if (state is Partner) {
                  final List<Campaign> campaigns = state.campaigns;

                  if (campaigns.isEmpty) {
                    return Stack(
                      children: [
                        const EmptyCampaigns(),
                        SettingsRedirect(partner: partnerState.partner),
                      ],
                    );
                  }

                  return ListView(
                    padding: context.mediumPadding,
                    children: [
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

                if (state is PartnerCampaignsError) {
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

class SettingsRedirect extends StatefulWidget {
  final PartnerUser partner;

  const SettingsRedirect({super.key, required this.partner});

  @override
  State<SettingsRedirect> createState() => _SettingsRedirectState();
}

class _SettingsRedirectState extends State<SettingsRedirect> {
  @override
  void initState() {
    super.initState();
    if (widget.partner.imageUrl == null) {
      final isRegisterShown = GetStorage().read('isRegisterShown') ?? false;

      if (isRegisterShown) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              partner: widget.partner,
              directed: true,
            ),
          ),
        );

        GetStorage().write('isRegisterShown', true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
