import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:models/models.dart';
import 'package:user/bloc/campaign/campaign_bloc.dart';
import 'package:user/bloc/user/user_bloc.dart';
import 'package:user/data/categories.dart';
import 'package:user/screens/home/widgets/campaign_card.dart';
import 'package:user/screens/home/widgets/location_permission.dart';
import 'package:user/screens/home/widgets/search_card.dart';
import 'package:user/widgets/wave_dots.dart';

final List<String> categories = [
  'En Yakındakiler',
  '⭐ Favoriler',
  'Market',
  'Yemek',
  'Giyim',
  'Kozmetik',
  'Optik',
  'Bar',
  'Petshop',
];

class CampaignsList extends StatefulWidget {
  final bool isPartner;

  const CampaignsList({super.key, required this.isPartner});

  @override
  State<CampaignsList> createState() => _CampaignsListState();
}

class _CampaignsListState extends State<CampaignsList> {
  late Map<String, dynamic>? geo;
  late bool firstTime;
  TextEditingController controller = TextEditingController();
  List<Campaign> filteredCampaigns = [];
  List<Campaign> campaigns = [];
  String selectedCategory = 'En Yakındakiler';

  void listenStorageChanges() {
    GetStorage().listenKey('geo', (value) {
      setState(() {
        geo = value;
      });
    });
    GetStorage().listenKey('firstLogin', (value) {
      if (mounted) {
        setState(() {
          firstTime = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_filterCampaigns);
    geo = GetStorage().read('geo');
    firstTime = GetStorage().read('firstLogin') ?? true;
    listenStorageChanges();
  }

  void _filterCampaigns() {
    setState(() {
      filteredCampaigns = campaigns.where((campaign) {
        final searchQuery = controller.text.toLowerCase();
        return campaign.category.toLowerCase().contains(searchQuery) || campaign.productName.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    controller
      ..removeListener(_filterCampaigns)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      return const Center(child: WaveDots());
    }

    if (geo == null) {
      return const LocationPermission();
    }

    if (widget.isPartner) {
      categories.remove('⭐ Favoriler');
    }

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        List<dynamic> userFavorites = [];

        if (userState is UserLoaded) {
          userFavorites = userState.user.favorites;
        }

        return BlocBuilder<CampaignBloc, CampaignState>(
          builder: (context, state) {
            if (state is CampaignsLoaded) {
              final allCampaigns = List<Campaign>.from(state.campaigns)..removeWhere((campaign) => !campaign.isVisible || campaign.freezed);

              // Get unique owner IDs to show only one of the campaigns of the same owner
              final List<String> uniqueOwners = allCampaigns.map((campaign) => campaign.companyID).toSet().toList();

              campaigns = uniqueOwners.map((owner) {
                final List<Campaign> ownerCampaigns = allCampaigns.where((campaign) => campaign.companyID == owner).toList();
                return ownerCampaigns.first;
              }).toList();

              final filteredCampaignsByHourAndCategory = campaigns.where((campaign) {
                final now = DateTime.now();
                final nowHour = now.hour + now.minute / 60;
                final endTimestamp = campaign.end.toDate();
                final endTimeStampHour = endTimestamp.hour + endTimestamp.minute / 60;

                return nowHour < endTimeStampHour &&
                    isCategoryMatched(
                      selectedCategory: selectedCategory,
                      campaign: campaign,
                      userFavorites: userFavorites,
                    );
              }).toList();

              final List<Campaign> selectedList = controller.text.isEmpty ? filteredCampaignsByHourAndCategory : filteredCampaigns;

              final existingCategories = categories.where((category) {
                return campaigns.any((campaign) => isCategoryMatched(selectedCategory: category, campaign: campaign, userFavorites: userFavorites));
              }).toList();

              if (campaigns.isEmpty) {
                return const Center(child: Text('Yakınlarda kampanya bulunamadı.'));
              }

              return BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserLoaded) {
                    final AppUser user = userState.user;
                    final List<dynamic> favorites = user.favorites;

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SearchCard(
                          controller: controller,
                        ),
                        context.mediumGap,
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: existingCategories
                                .map(
                                  (category) => Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: ChoiceChip(
                                      label: Text(category),
                                      selected: selectedCategory == category,
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedCategory = category;
                                          if (category == 'En Yakındakiler') {
                                            filteredCampaigns = campaigns;
                                          } else if (category == '⭐ Favoriler') {
                                            filteredCampaigns = campaigns.where((campaign) => favorites.contains(campaign.id)).toList();
                                          } else if (category == 'Market') {
                                            filteredCampaigns = campaigns.where((campaign) => shopCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Yemek') {
                                            filteredCampaigns = campaigns.where((campaign) => foodCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Giyim') {
                                            filteredCampaigns = campaigns.where((campaign) => clotheCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Kozmetik') {
                                            filteredCampaigns = campaigns.where((campaign) => cosmeticCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Optik') {
                                            filteredCampaigns = campaigns.where((campaign) => opticalCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Bar') {
                                            filteredCampaigns = campaigns.where((campaign) => barCategories.contains(campaign.category)).toList();
                                          } else if (category == 'Petshop') {
                                            filteredCampaigns = campaigns.where((campaign) => petshopCategories.contains(campaign.category)).toList();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        context.mediumGap,
                        GridView(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .62,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: selectedList
                              .map(
                                (campaign) => CampaignCard(
                                  isPartner: widget.isPartner,
                                  campaign: campaign,
                                  favorites: favorites,
                                  geo: geo!,
                                  otherCampaignsOfCompany: state.campaigns.where((c) => c.companyID == campaign.companyID).toList(),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  }

                  return const Center(child: WaveDots());
                },
              );
            }

            return const Center(child: WaveDots());
          },
        );
      },
    );
  }
}

bool isCategoryMatched({
  required String selectedCategory,
  required Campaign campaign,
  required List<dynamic> userFavorites,
}) {
  if (selectedCategory == 'En Yakındakiler') {
    return true;
  }

  if (selectedCategory == '⭐ Favoriler') {
    return userFavorites.contains(campaign.id);
  }

  if (selectedCategory == 'Market') {
    return shopCategories.contains(campaign.category);
  }

  if (selectedCategory == 'Yemek') {
    return foodCategories.contains(campaign.category);
  }

  if (selectedCategory == 'Giyim') {
    return clotheCategories.contains(campaign.category);
  }

  if (selectedCategory == 'Kozmetik') {
    return cosmeticCategories.contains(campaign.category);
  }

  if (selectedCategory == 'Optik') {
    return opticalCategories.contains(campaign.category);
  }

  if (selectedCategory == 'Bar') {
    return barCategories.contains(campaign.category);
  }

  return false;
}
