import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/screens/settings/screens/theme_screen.dart';
import 'package:user/services/adapty_service.dart';
import 'package:user/widgets/containers.dart';
import 'package:user/widgets/list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: context.mediumHorizontalPadding,
        child: Column(
          children: [
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
                      onTap: () {
                        GetStorage().write('signedOutFromUser', true);
                        GetStorage().write('accountType', null);
                        EpiFirebaseAuth.instance.signOut();
                        GetStorage().remove('isRegisterShown');
                      },
                      title: 'Partner Hesabına Geç',
                      leadingIcon: Icons.account_circle_rounded,
                      leadingColor: Colors.orangeAccent,
                    ),
                  ],
                ).toList(),
              ),
            ),
            context.largeGap,
            Column(
              children: [
                Text('Haem', style: context.theme.textTheme.titleLarge),
                Text('v1.1.72.20 ', style: context.theme.textTheme.bodyLarge),
                // context.smallGap,
                // Text(
                //   'BETA',
                //   style: context.theme.textTheme.labelMedium!.copyWith(
                //     color: context.theme.colorScheme.error,
                //   ),
                // ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text('from', style: context.theme.textTheme.labelMedium),
                Text('Haem', style: context.theme.textTheme.titleMedium),
              ],
            ),
            context.largeGap,
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
}
