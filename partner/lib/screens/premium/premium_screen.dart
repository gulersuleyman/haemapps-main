import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:partner/screens/premium/widgets/plan_card.dart';
import 'package:partner/services/adapty_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends StatefulWidget {
  static const path = '/premium';

  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isPro = FirebaseAuth.instance.currentUser?.displayName == 'pro';
  List<AdaptyPaywallProduct?> products = [];
  String selectedPlan = 'annual';
  bool isPurchaseSuccessfull = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    final adaptyProducts = await AdaptyService.instance.getProducts();
    setState(() {
      products = adaptyProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdaptyPaywallProduct? monthly;
    AdaptyPaywallProduct? annual;
    String? annualSavingPercent;

    if (products.isNotEmpty) {
      monthly = products.firstWhere((element) => element?.vendorProductId == 'haem_monthly');
      annual = products.firstWhere((element) => element?.vendorProductId == 'haem_annual');

      final double annualMonthlyPrice = annual!.price.amount / 12;
      final double monthlyMonthlyPrice = monthly!.price.amount;

      final annualSavings = ((monthlyMonthlyPrice - annualMonthlyPrice) / monthlyMonthlyPrice) * 100;

      annualSavingPercent = annualSavings.toStringAsFixed(0);
    }

    if (isPro) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            '🎉 Haem Pro`ya sahipsiniz!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.onPrimaryContainer,
        body: Column(
          children: [
            context.largeGap,
            context.mediumGap,
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                context.mediumGap,
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: context.mediumHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Haem Premium',
                      style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    context.smallGap,
                    Row(
                      children: [
                        const Icon(Icons.speed_rounded, color: Colors.white),
                        context.smallGap,
                        Text('Sınırsız gönderi oluştur', style: context.theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
                      ],
                    ),
                    context.mediumGap,
                    if (products.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      Column(
                        children: [
                          PlanCard(
                            product: monthly!,
                            selected: selectedPlan == 'monthly',
                            onTap: () => setState(() => selectedPlan = 'monthly'),
                          ),
                          context.smallGap,
                          PlanCard(
                            product: annual!,
                            selected: selectedPlan == 'annual',
                            onTap: () => setState(() => selectedPlan = 'annual'),
                            savingPercent: annualSavingPercent,
                          ),
                        ],
                      ),
                    context.mediumGap,
                    FilledButton(
                      onPressed: onPurchase,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment_rounded),
                          context.smallGap,
                          Text(
                            'Devam et',
                            style: context.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    context.smallGap,
                    RichText(
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Abonelik, cari dönemin bitiminden en az 24 saat önce otomatik yenileme kapatılmadığı sürece otomatik olarak yenilenir. \n\n',
                        style: context.theme.textTheme.labelMedium,
                        children: [
                          TextSpan(
                            text: ' Gizlilik Politikası',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await openURL(Uri.parse('https://haemdata.web.app/privacy.html'));
                              },
                            style: context.theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                          TextSpan(
                            text: '   |   ',
                            style: context.theme.textTheme.labelMedium,
                          ),
                          TextSpan(
                            text: ' Kullanım Şartları.',
                            style: context.theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await openURL(Uri.parse('https://haemdata.web.app/eula.html'));
                              },
                          ),
                        ],
                      ),
                    ),
                    context.largeGap,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> onPurchase() async {
    AdaptyPaywallProduct product;

    switch (selectedPlan) {
      case 'monthly':
        product = products.firstWhere((element) => element?.vendorProductId == 'haem_monthly')!;
      case 'annual':
        product = products.firstWhere((element) => element?.vendorProductId == 'haem_annual')!;
      default:
        throw Exception('Invalid plan');
    }

    await AdaptyService.instance.makePurchase(product);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isPro = FirebaseAuth.instance.currentUser?.displayName == 'pro';
      });
    });
  }
}
