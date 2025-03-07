import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:user/widgets/wave_dots.dart';

class CampaignDetails extends StatefulWidget {
  final Campaign campaign;
  final PartnerUser partner;

  const CampaignDetails({super.key, required this.campaign, required this.partner});

  @override
  State<CampaignDetails> createState() => _CampaignDetailsState();
}

class _CampaignDetailsState extends State<CampaignDetails> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String endMonth = widget.campaign.end.toDate().month.toString();
    final String endDay = widget.campaign.end.toDate().day.toString();
    final String endHour = widget.campaign.end.toDate().hour.toString();
    final String endMinute = widget.campaign.end.toDate().minute.toString();

    final allImages = [(widget.campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas'), ...widget.campaign.multipleImages];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.campaign.id,
                    child: SizedBox(
                      width: double.infinity,
                      height: 275,
                      child: widget.campaign.multipleImages.isEmpty
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.campaign.image ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: WaveDots(
                                        color: context.theme.colorScheme.primary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: -10,
                                  left: 0,
                                  child: SafeArea(
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
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
                                    return Image.network(
                                      allImages[index],
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
                                Positioned(
                                  top: -10,
                                  left: 0,
                                  child: SafeArea(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: context.theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: context.mediumPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Son Gün: $endDay ${getMonthName(endMonth)['name']}${' ${endHour.padLeft(2, '0')}:${endMinute.padLeft(2, '0')}'}',
                          style: context.theme.textTheme.labelLarge,
                        ),
                        Text(
                          widget.campaign.title.capitalize,
                          style: context.theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        context.smallGap,
                        SizedBox(
                          height: 25,
                          child: Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: widget.partner.imageUrl == null ? context.theme.colorScheme.surfaceContainer : null,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: widget.partner.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.partner.imageUrl ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                                          fit: BoxFit.cover,
                                          height: 25,
                                          width: 25,
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      )
                                    : const Icon(Icons.account_circle_rounded, size: 30),
                              ),
                              context.tinyGap,
                              Expanded(
                                child: Text(
                                  widget.partner.name,
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
                          widget.campaign.description,
                          style: context.theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
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
                  const Spacer(),
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        showAdaptiveDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(widget.campaign.freezed ? 'Kampanyayı Devam Ettir' : 'Kampanyayı Durdur'),
                              content: Text(
                                widget.campaign.freezed
                                    ? 'Kampanya tekrar müşteriler tarafından görülebilir olacak. Devam etmek istediğinize emin misiniz?'
                                    : 'Kampanya durdurulduğunda müşteriler kampanyayı göremeyecek. Devam etmek istediğinize emin misiniz?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    FirebaseFirestore.instance.collection('campaigns').doc(widget.campaign.id).update({
                                      'freezed': !widget.campaign.freezed,
                                    });
                                  },
                                  child: Text(widget.campaign.freezed ? 'Devam' : 'Durdur'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Text(
                        widget.campaign.freezed ? 'Devam Ettir' : 'Durdur',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      icon: Icon(
                        widget.campaign.freezed ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  context.smallGap,
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        showAdaptiveDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text('Kampanya Silinecek'),
                              content: const Text('Kampanyayı silmek istediğinize emin misiniz?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    FirebaseFirestore.instance.collection('campaigns').doc(widget.campaign.id).delete();
                                  },
                                  child: const Text('Sil'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: const Text(
                        'Kampanyayı Sil',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white),
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
