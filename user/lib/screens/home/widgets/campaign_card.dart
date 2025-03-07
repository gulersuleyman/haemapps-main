import 'package:cached_network_image/cached_network_image.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:models/models.dart';
import 'package:user/data/categories.dart';
import 'package:user/screens/details/campaign_details.dart';
import 'package:user/screens/home/widgets/company_details.dart';
import 'package:user/services/user_service.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final List<dynamic> favorites;
  final Map<String, dynamic> geo;
  final List<Campaign> otherCampaignsOfCompany;
  final bool minimal;
  final bool isPartner;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.favorites,
    required this.geo,
    required this.otherCampaignsOfCompany,
    this.minimal = false,
    this.isPartner = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = favorites.contains(campaign.id);

    final double distance = Geolocator.distanceBetween(
      geo['lat'] as double,
      geo['lon'] as double,
      campaign.geo['geopoint'].latitude,
      campaign.geo['geopoint'].longitude,
    );

    return GestureDetector(
      onTap: () {
        if (!minimal) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompanyDetails(
                otherCampaignsOfCompany: otherCampaignsOfCompany,
                favorites: favorites,
                geo: geo,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CampaignDetails(
                campaign: campaign,
                isFavorite: isFavorite,
                distance: distance,
                otherCampaignsOfCompany: otherCampaignsOfCompany,
                isPartner: isPartner,
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: minimal ? '${campaign.id}_minimal_card' : campaign.id,
            child: Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: context.theme.colorScheme.surfaceContainer,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            (minimal ? campaign.image : campaign.companyImage) ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: (!isPartner)
                        ? Row(
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
                              GestureDetector(
                                onTap: () async {
                                  if (isFavorite) {
                                    await UserService.instance.removeCampaignFromFavorites(campaign.id);
                                  } else {
                                    await UserService.instance.addCampaignToFavorites(campaign.id);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: context.theme.colorScheme.scrim,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? context.theme.colorScheme.primary : context.theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  minimal ? campaign.productName.capitalize : campaign.companyName.capitalize,
                  style: context.theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                context.tinyGap,
                Text(
                  campaign.category,
                  style: context.theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.tinyGap,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCampaignDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: CampaignDetails(
            minimal: true,
            campaign: campaign,
            isFavorite: favorites.contains(campaign.id),
            distance: Geolocator.distanceBetween(
              geo['lat'] as double,
              geo['lon'] as double,
              campaign.geo['geopoint'].latitude,
              campaign.geo['geopoint'].longitude,
            ),
            otherCampaignsOfCompany: otherCampaignsOfCompany,
          ),
        );
      },
    );
  }
}
