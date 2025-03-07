import 'package:cached_network_image/cached_network_image.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/data/categories.dart';
import 'package:user/widgets/wave_dots.dart';

class OtherCampaigns extends StatelessWidget {
  final List<Campaign> campaigns;
  final Function(Campaign) onCampaignTap;

  const OtherCampaigns({super.key, required this.campaigns, required this.onCampaignTap});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .6,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: campaigns.map((campaign) {
        return GestureDetector(
          onTap: () => onCampaignTap(campaign),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 220,
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          context.tinyGap,
                          if (campaign.yemeksepetiLink != null && foodCategories.contains(campaign.category))
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/yemeksepeti.jpeg',
                                  width: 27,
                                  height: 27,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          if (campaign.yemeksepetiLink != null) context.tinyGap,
                          if (campaign.getirLink != null && (shopCategories.contains(campaign.category) || foodCategories.contains(campaign.category)))
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/getir.png',
                                  width: 27,
                                  height: 27,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
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
                  Text(
                    campaign.productName.capitalize,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                  context.tinyGap,
                  SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: campaign.companyImage == null ? context.theme.colorScheme.surfaceContainer : null,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: campaign.companyImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: campaign.companyImage!,
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
                            campaign.companyName,
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
      }).toList(),
    );
  }
}
