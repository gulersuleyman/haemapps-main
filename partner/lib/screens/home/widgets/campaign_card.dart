import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:partner/screens/details/campaign_details.dart';

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
                image: DecorationImage(
                  image: NetworkImage(campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas'),
                  fit: BoxFit.cover,
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
                              child: Image.network(
                                partner.imageUrl!,
                                height: 25,
                                width: 25,
                                fit: BoxFit.cover,
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
