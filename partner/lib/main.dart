import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partner/bloc/campaign/campaign_bloc.dart';
import 'package:partner/bloc/partner/partner_bloc.dart';
import 'package:partner/cubit/navigation/navigation_cubit.dart';
import 'package:partner/firebase_options.dart';
import 'package:partner/router.dart';
import 'package:partner/services/adapty_service.dart';
import 'package:partner/theme/controller.dart';
import 'package:partner/theme/dark.dart';
import 'package:partner/theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdaptyService.instance.getAdaptyProfile();
  runApp(const PartnerApp());
}

class PartnerApp extends StatefulWidget {
  const PartnerApp({super.key});

  @override
  State<PartnerApp> createState() => _PartnerAppState();
}

class _PartnerAppState extends State<PartnerApp> {
  bool isDarkModeEnabled = ThemeController().isDarkModeEnabled();
  Map<String, dynamic>? geo = GetStorage().read('geo');

  void listenThemeChanges() {
    GetStorage().listenKey('isDark', (value) {
      setState(() {
        isDarkModeEnabled = value;
      });
    });
    GetStorage().listenKey('geo', (value) {
      setState(() {
        geo = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenThemeChanges();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isDarkModeEnabled ? darkTheme : lightTheme;

    return StreamBuilder<EpiUser?>(
      stream: EpiFirebaseAuth.instance.authStateChanges,
      builder: (context, snapshot) {
        final bool isAuthenticated = snapshot.data?.uid != null;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => NavigationCubit()),
          ],
          child: buildMaterialApp(isAuthenticated ? snapshot.data?.uid : null, theme),
        );
      },
    );
  }

  Widget buildMaterialApp(String? userID, ThemeData? theme) {
    if (userID == null) {
      return MaterialApp.router(
        title: 'Partner App',
        routerConfig: authRouter,
        theme: theme,
        debugShowCheckedModeBanner: false,
      );
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CampaignBloc()..add(LoadCampaigns(userID: userID))),
          BlocProvider(create: (_) => PartnerBloc()..add(LoadPartner(userID: userID))),
        ],
        child: MaterialApp.router(
          title: 'Partner App',
          routerConfig: appRouter,
          theme: theme,
          debugShowCheckedModeBanner: false,
        ),
      );
    }
  }
}
