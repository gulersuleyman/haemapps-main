import 'package:go_router/go_router.dart';
import 'package:partner/create/create_campaign.dart';
import 'package:partner/screens/auth/auth_screen.dart';
import 'package:partner/screens/landing/landing_screen.dart';
import 'package:partner/screens/premium/premium_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LandigScreen()),
    GoRoute(path: CreateCampaign.path, builder: (_, __) => const CreateCampaign()),
    GoRoute(path: PremiumScreen.path, builder: (_, __) => const PremiumScreen()),
  ],
);

final GoRouter authRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const AuthScreen()),
  ],
);
