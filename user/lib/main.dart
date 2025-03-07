import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/bloc/appointment_posts/appointment_posts_bloc.dart';
import 'package:user/bloc/campaign/campaign_bloc.dart';
import 'package:user/bloc/user/user_bloc.dart';
import 'package:user/cubit/navigation/navigation_cubit.dart';
import 'package:user/firebase_options.dart';
import 'package:user/partner_bloc/appointment/appointments_bloc.dart';
import 'package:user/partner_bloc/appointment_post/appointment_post_bloc.dart';
import 'package:user/partner_bloc/campaign/campaign_bloc.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_cubit/navigation/navigation_cubit.dart';
import 'package:user/router.dart';
import 'package:user/services/adapty_service.dart';
import 'package:user/theme/controller.dart';
import 'package:user/theme/dark.dart';
import 'package:user/theme/light.dart';
import 'package:user/theme/partner_dark.dart';
import 'package:user/theme/partner_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdaptyService.instance.getAdaptyProfile();
  runApp(const UserApp());
}

class UserApp extends StatefulWidget {
  const UserApp({super.key});

  @override
  State<UserApp> createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  bool isDarkModeEnabled = ThemeController().isDarkModeEnabled();
  Map<String, dynamic>? geo = GetStorage().read('geo');
  String accountType = GetStorage().read('accountType') ?? 'user';

  void listenStorageChanges() {
    GetStorage().listenKey('isDark', (value) {
      setState(() {
        isDarkModeEnabled = value;
      });
    });
    GetStorage().listenKey('geo', (value) {
      if (!mounted) return;

      setState(() {
        geo = value;
      });
    });
    GetStorage().listenKey('accountType', (value) {
      setState(() {
        accountType = value ?? 'user';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenStorageChanges();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isDarkModeEnabled ? darkTheme : lightTheme;

    return StreamBuilder<EpiUser?>(
      stream: EpiFirebaseAuth.instance.authStateChanges,
      builder: (context, snapshot) {
        final bool isAuthenticated = snapshot.data?.uid != null;

        if (isAuthenticated) {
          final bool isPartner = accountType == 'partner';

          if (isPartner) {
            return buildPartnerMaterialApp(snapshot.data!.uid, geo,
                isDark: isDarkModeEnabled);
          } else {
            return buildMaterialApp(snapshot.data!.uid, theme, geo: geo);
          }
        }

        return MaterialApp.router(
          title: 'Hem',
          theme: theme,
          routerConfig: authRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  Widget buildPartnerMaterialApp(String userID, Map<String, dynamic>? geo,
      {required bool isDark}) {
    final ThemeData theme =
        isDarkModeEnabled ? partnerDarkTheme : partnerLightTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => PartnerNavigationCubit()),
        BlocProvider(
            create: (_) => PartnerCampaignBloc()
              ..add(LoadPartnerCampaigns(userID: userID))),
        BlocProvider(
            create: (_) => PartnerBloc()..add(LoadPartner(userID: userID))),
        BlocProvider(create: (_) => UserBloc()..add(LoadUser(userID: userID))),
        BlocProvider(
            create: (_) => CampaignBloc()..add(LoadCampaigns(geo: geo ?? {}))),
        BlocProvider(
            create: (_) => AppointmentPostBloc()
              ..add(LoadAppointmentPost(userID: userID))),
        BlocProvider(
            create: (_) =>
                AppointmentsBloc()..add(LoadAppointments(userID: userID))),
      ],
      child: MaterialApp.router(
        title: 'Hem', // Partner App
        routerConfig: partnerAppRouter,
        theme: theme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget buildMaterialApp(String? userID, ThemeData? theme,
      {Map<String, dynamic>? geo}) {
    if (geo == null && userID == null) {
      return getMaterialApp(userID, theme);
    } else if (geo == null && userID != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
              create: (_) => UserBloc()..add(LoadUser(userID: userID))),
        ],
        child: getMaterialApp(userID, theme),
      );
    } else if (geo != null && userID == null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
              create: (_) => CampaignBloc()..add(LoadCampaigns(geo: geo))),
          BlocProvider(
              create: (_) =>
                  AppointmentPostsBloc()..add(LoadAppointmentPosts(geo: geo))),
        ],
        child: getMaterialApp(userID, theme),
      );
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider(
              create: (_) => UserBloc()..add(LoadUser(userID: userID!))),
          BlocProvider(
              create: (_) => CampaignBloc()..add(LoadCampaigns(geo: geo!))),
          BlocProvider(
              create: (_) =>
                  AppointmentPostsBloc()..add(LoadAppointmentPosts(geo: geo!))),
        ],
        child: getMaterialApp(userID, theme),
      );
    }
  }

  Widget getMaterialApp(String? userID, ThemeData? theme) {
    return MaterialApp.router(
      title: 'Hem', // User App
      theme: theme,
      routerConfig: userID == null ? authRouter : appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
