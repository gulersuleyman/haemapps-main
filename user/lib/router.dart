import 'package:go_router/go_router.dart';
import 'package:user/auth/auth_screen.dart';
import 'package:user/partner_screens/create/create_campaign.dart';
import 'package:user/partner_screens/landing/landing_screen.dart';
import 'package:user/partner_screens/premium/premium_screen.dart';
import 'package:user/screens/landing/landing_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LandingScreen()),
  ],
);

final GoRouter authRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const AuthScreen()),
  ],
);

final GoRouter partnerAppRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const PartnerLandingScreen()),
    GoRoute(path: CreateCampaign.path, builder: (_, __) => const CreateCampaign()),
    GoRoute(path: PremiumScreen.path, builder: (_, __) => const PremiumScreen()),
  ],
);
