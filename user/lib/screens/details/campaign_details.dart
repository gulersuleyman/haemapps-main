import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/data/categories.dart';
import 'package:user/services/user_service.dart';

class CampaignDetails extends StatefulWidget {
  final Campaign campaign;
  final bool isFavorite;
  final double distance;
  final List<Campaign> otherCampaignsOfCompany;
  final bool minimal;
  final bool isPartner;

  const CampaignDetails({
    super.key,
    required this.campaign,
    required this.isFavorite,
    required this.distance,
    required this.otherCampaignsOfCompany,
    this.minimal = false,
    this.isPartner = false,
  });
  @override
  State<CampaignDetails> createState() => _CampaignDetailsState();
}

class _CampaignDetailsState extends State<CampaignDetails> {
  late bool isFavorite;
  late Campaign campaign;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    campaign = widget.campaign;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GeoPoint geo = campaign.geo['geopoint'];
    final String endMonth = campaign.end.toDate().month.toString();
    final String endDay = campaign.end.toDate().day.toString();
    final String endHour = campaign.end.toDate().hour.toString();
    final String endMinute = campaign.end.toDate().minute.toString();

    final allImages = [(campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas'), ...campaign.multipleImages];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.minimal ? '${campaign.id}_minimal' : campaign.id,
                    child: SizedBox(
                      width: double.infinity,
                      height: 275,
                      child: campaign.multipleImages.isEmpty
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SafeArea(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: widget.minimal ? 20 : 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: context.theme.colorScheme.surface,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: IconButton(
                                            icon: widget.minimal ? const Icon(Icons.close) : const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        if (!widget.isPartner)
                                          Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: context.theme.colorScheme.surface,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? context.theme.colorScheme.primary : context.theme.colorScheme.onSurface,
                                              ),
                                              onPressed: () {
                                                if (isFavorite) {
                                                  setState(() => isFavorite = false);
                                                  UserService.instance.removeCampaignFromFavorites(campaign.id);
                                                } else {
                                                  setState(() => isFavorite = true);
                                                  UserService.instance.addCampaignToFavorites(campaign.id);
                                                }
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: allImages.length,
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                      imageUrl: allImages[index],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        allImages.length,
                                        (index) => AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                          height: 8.0,
                                          width: _currentPage == index ? 12.0 : 8.0,
                                          decoration: BoxDecoration(
                                            color: _currentPage == index ? Colors.white : Colors.grey,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: widget.minimal ? 20 : 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: context.theme.colorScheme.surface,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: IconButton(
                                            icon: widget.minimal ? const Icon(Icons.close) : const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        if (!widget.isPartner)
                                          Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: context.theme.colorScheme.surface,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? context.theme.colorScheme.primary : context.theme.colorScheme.onSurface,
                                              ),
                                              onPressed: () {
                                                if (isFavorite) {
                                                  setState(() => isFavorite = false);
                                                  UserService.instance.removeCampaignFromFavorites(campaign.id);
                                                } else {
                                                  setState(() => isFavorite = true);
                                                  UserService.instance.addCampaignToFavorites(campaign.id);
                                                }
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: context.mediumHorizontalPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.smallGap,
                        Row(
                          children: [
                            Text(
                              'Son Gün: $endDay ${getMonthName(endMonth)['name']}${' ${endHour.padLeft(2, '0')}:${endMinute.padLeft(2, '0')}'}',
                              style: context.theme.textTheme.labelLarge,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final TextEditingController controller = TextEditingController();

                                    return AlertDialog(
                                      title: const Text('Şikayet Et'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Lütfen kampanya hakkında şikayetinizi belirtin'),
                                          context.smallGap,
                                          CupertinoTextField(
                                            controller: controller,
                                            placeholder: 'Şikayetiniz...',
                                            maxLines: 5,
                                            decoration: BoxDecoration(
                                              color: context.theme.colorScheme.surfaceContainer,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('İptal', style: context.theme.textTheme.labelLarge),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (controller.text.isEmpty) return;

                                            FirebaseFirestore.instance.collection('complaints').add({
                                              'campaignID': campaign.id,
                                              'complaint': controller.text,
                                            });

                                            Navigator.of(context).pop();

                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şikayetiniz alınmıştır')));
                                          },
                                          child:
                                              Text('Şikayet Et', style: context.theme.textTheme.labelLarge!.copyWith(color: context.theme.colorScheme.error)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Şikayet Et', style: context.theme.textTheme.labelLarge!.copyWith(color: context.theme.colorScheme.error)),
                            ),
                          ],
                        ),
                        context.tinyGap,
                        Text(
                          campaign.title.capitalize,
                          style: context.theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          campaign.productName.capitalize,
                          style: context.theme.textTheme.bodyMedium,
                        ),
                        context.tinyGap,
                        if (!widget.minimal)
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
                                            imageUrl: campaign.companyImage ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
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
                        context.smallGap,
                        Text(
                          campaign.description,
                          style: context.theme.textTheme.labelLarge,
                        ),
                        context.smallGap,
                        if (campaign.menuLink != null && !widget.minimal)
                          FilledButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse(campaign.menuLink!));
                            },
                            label: const Text('Restoran Menüsünü Görüntüle'),
                            icon: const Icon(Icons.restaurant_menu_rounded),
                          ),
                        context.smallGap,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              height: 75,
              padding: context.mediumPadding,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainerLow,
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.shadow,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (campaign.yemeksepetiLink == null && campaign.getirLink == null)
                    Text(
                      '${(widget.distance / 1000).toStringAsFixed(1)} km uzaklıkta',
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (campaign.yemeksepetiLink != null && foodCategories.contains(campaign.category))
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(campaign.yemeksepetiLink!), mode: LaunchMode.externalApplication);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/yemeksepeti.jpeg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  if (campaign.yemeksepetiLink != null) context.smallGap,
                  if (campaign.getirLink != null && (shopCategories.contains(campaign.category) || foodCategories.contains(campaign.category)))
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(campaign.getirLink!), mode: LaunchMode.externalApplication);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/getir.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        openMap(geo.latitude, geo.longitude);
                      },
                      label: const Text(
                        'Yol Tarifi',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      icon: const Icon(Icons.directions, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String mapUrl;

    if (Platform.isIOS) {
      mapUrl = 'http://maps.apple.com/?q=$latitude,$longitude';
    } else {
      mapUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    }
  }
}

Map<String, String> getMonthName(String month) {
  switch (month) {
    case '1':
      return {'name': 'Ocak', 'short': 'Oca'};
    case '2':
      return {'name': 'Şubat', 'short': 'Şub'};
    case '3':
      return {'name': 'Mart', 'short': 'Mar'};
    case '4':
      return {'name': 'Nisan', 'short': 'Nis'};
    case '5':
      return {'name': 'Mayıs', 'short': 'May'};
    case '6':
      return {'name': 'Haziran', 'short': 'Haz'};
    case '7':
      return {'name': 'Temmuz', 'short': 'Tem'};
    case '8':
      return {'name': 'Ağustos', 'short': 'Ağu'};
    case '9':
      return {'name': 'Eylül', 'short': 'Eyl'};
    case '10':
      return {'name': 'Ekim', 'short': 'Eki'};
    case '11':
      return {'name': 'Kasım', 'short': 'Kas'};
    case '12':
      return {'name': 'Aralık', 'short': 'Ara'};
    default:
      return {'name': '', 'short': ''};
  }
}
