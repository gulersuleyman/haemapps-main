import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/screens/home/widgets/campaign_card.dart';

class CompanyDetails extends StatelessWidget {
  final List<Campaign> otherCampaignsOfCompany;
  final List<dynamic> favorites;
  final Map<String, dynamic> geo;

  const CompanyDetails({
    super.key,
    required this.otherCampaignsOfCompany,
    required this.favorites,
    required this.geo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherCampaignsOfCompany.first.companyName),
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .62,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        children: otherCampaignsOfCompany.map((campaign) {
          return CampaignCard(
            campaign: campaign,
            favorites: favorites,
            geo: geo,
            otherCampaignsOfCompany: otherCampaignsOfCompany,
            minimal: true,
          );
        }).toList(),
      ),
    );
  }
}
