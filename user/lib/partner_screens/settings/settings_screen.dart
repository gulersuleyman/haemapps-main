import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_screens/premium/premium_screen.dart';
import 'package:user/partner_screens/settings/screens/edit_profile_screen.dart';
import 'package:user/partner_screens/settings/screens/theme_screen.dart';
import 'package:user/partner_screens/settings/widgets/location_card.dart';
import 'package:user/screens/home/home_screen.dart';
import 'package:user/services/adapty_service.dart';
import 'package:user/widgets/containers.dart';
import 'package:user/widgets/list_tile.dart';
import 'package:user/widgets/wave_dots.dart';

class PartnerSettingsScreen extends StatelessWidget {
  const PartnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, state) {
          if (state is PartnerLoaded) {
            return Padding(
              padding: context.mediumHorizontalPadding,
              child: ListView(
                children: [
                  const LocationCard(),
                  context.mediumGap,
                  EpiContainer.rounded(
                    color: context.theme.colorScheme.surfaceContainer,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Column(
                      children: ListTile.divideTiles(
                        color: context.theme.colorScheme.surfaceContainer,
                        tiles: [
                          EpiListTile(
                            title: 'Tema',
                            leadingIcon: Icons.palette_rounded,
                            leadingColor: context.theme.colorScheme.primary,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ThemeScreen(),
                                ),
                              );
                            },
                          ),
                          EpiListTile(
                            title: 'Abonelik',
                            leadingIcon: Icons.account_circle_rounded,
                            leadingColor: Colors.purple,
                            onTap: () {
                              context.push(PremiumScreen.path);
                            },
                          ),
                          EpiListTile(
                            title: 'Abonelik Geri Yükle',
                            leadingIcon: Icons.account_circle_rounded,
                            leadingColor: Colors.purpleAccent,
                            onTap: () async {
                              final bool approved = await showAdaptiveDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('Abonelik Geri Yükle'),
                                    content: const Text('Aboneliğinizi geri yüklemek istediğinize emin misiniz?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Onayla'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (approved) {
                                await Adapty().restorePurchases();
                                await AdaptyService.instance.getAdaptyProfile();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Abonelik geri yüklendi.'),
                                  ),
                                );
                              }
                            },
                          ),
                          EpiListTile(
                            title: 'Hesap Bilgileri',
                            leadingIcon: Icons.account_circle_rounded,
                            leadingColor: Colors.green,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    partner: state.partner,
                                  ),
                                ),
                              );
                            },
                          ),
                          EpiListTile(
                            title: 'Hesabı Sil',
                            leadingIcon: Icons.delete_rounded,
                            leadingColor: Colors.red,
                            onTap: () {
                              showAdaptiveDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('Hesabı Sil'),
                                    content: const Text('Hesabınızı silmek istediğinize emin misiniz?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await showAdaptiveDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: const Text('Hesap Silme Talebi'),
                                                content: const Text('Hesap silme talebiniz alınmıştır. 30 gün içinde hesabınız tamamen silinecektir.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: const Text('Tamam'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          await FirebaseFirestore.instance.collection('deleteRequests').add(
                                            {
                                              'uid': EpiFirebaseAuth.instance.currentUser!.uid,
                                              'email': EpiFirebaseAuth.instance.currentUser!.email,
                                              'timestamp': FieldValue.serverTimestamp(),
                                            },
                                          );
                                        },
                                        child: const Text('Sil'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          EpiListTile(
                            onTap: () => openURL(Uri.parse('https://haemdata.web.app/eula.html')),
                            title: 'Kullanım Şartları',
                            leadingIcon: Icons.description_rounded,
                            leadingColor: Colors.blueAccent,
                          ),
                          EpiListTile(
                            onTap: () => openURL(Uri.parse('https://haemdata.web.app/privacy.html')),
                            title: 'Gizlilik Politikası',
                            leadingIcon: Icons.privacy_tip_rounded,
                            leadingColor: Colors.deepPurple,
                          ),
                          EpiListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(isPartner: true),
                                ),
                              );
                            },
                            title: 'Kampanyaları Keşfet',
                            leadingIcon: Icons.local_offer_rounded,
                          ),
                          EpiListTile(
                            title: 'User ID: ${FirebaseAuth.instance.currentUser?.uid.substring(0, 12)}..',
                            leadingIcon: Icons.numbers_rounded,
                            leadingColor: Colors.green,
                            customTrailing: Icon(
                              Icons.copy_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(text: FirebaseAuth.instance.currentUser?.uid ?? ''));
                            },
                          ),
                          EpiListTile(
                            onTap: () {
                              GetStorage().remove('signedOutFromUser');
                              GetStorage().remove('isRegisterShown');
                              EpiFirebaseAuth.instance.signOut();
                            },
                            title: 'Çıkış Yap',
                            leadingIcon: Icons.logout_rounded,
                            leadingColor: Colors.redAccent,
                            customTrailing: Icon(
                              Icons.logout_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ).toList(),
                    ),
                  ),
                  context.largeGap,
                  Column(
                    children: [
                      Text('Haem | Partner', style: context.theme.textTheme.titleLarge),
                      Text('v1.1.72.20', style: context.theme.textTheme.bodyLarge),
                      // context.smallGap,
                      // Text(
                      //   'BETA',
                      //   style: context.theme.textTheme.labelMedium!.copyWith(
                      //     color: context.theme.colorScheme.error,
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('from', style: context.theme.textTheme.labelMedium),
                      Text('Haem', style: context.theme.textTheme.titleMedium),
                    ],
                  ),
                  context.largeGap,
                ],
              ),
            );
          }

          return const Center(child: WaveDots());
        },
      ),
    );
  }

  Future<void> openURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
