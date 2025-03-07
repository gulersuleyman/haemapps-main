import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:user/screens/home/widgets/campaigns_list.dart';
import 'package:user/screens/home/widgets/location_card.dart';

class HomeScreen extends StatelessWidget {
  final bool isPartner;

  const HomeScreen({super.key, this.isPartner = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPartner ? AppBar() : null,
      body: SafeArea(
        child: ListView(
          padding: context.mediumPadding,
          children: [
            if (!isPartner) const LocationCard(),
            if (!isPartner) context.mediumGap,
            CampaignsList(isPartner: isPartner),
          ],
        ),
      ),
    );
  }
}
