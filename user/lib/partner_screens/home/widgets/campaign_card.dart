import 'package:cached_network_image/cached_network_image.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/partner_screens/details/campaign_details.dart';
import 'package:user/widgets/wave_dots.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final Map<String, dynamic> geo;
  final PartnerUser partner;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.geo,
    required this.partner,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CampaignDetails(
              campaign: campaign,
              partner: partner,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: campaign.id,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: WaveDots(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.tinyGap,
              Text(
                campaign.title.capitalize,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 25,
                child: Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: partner.imageUrl == null ? context.theme.colorScheme.surfaceContainer : null,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: partner.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                width: 25,
                                height: 25,
                                imageUrl: partner.imageUrl ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            )
                          : const Icon(Icons.account_circle_rounded, size: 27),
                    ),
                    context.tinyGap,
                    Expanded(
                      child: Text(
                        partner.name,
                        style: context.theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
