import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:epi_http/epi_http.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/cubit/navigation/navigation_cubit.dart';
import 'package:user/screens/landing/widgets/bottom_navigation_bar.dart';
import 'package:user/services/location.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingTransparencyRequest();
    });
    onAppStarted();
  }

  Future<void> onAppStarted() async {
    final EpiResponse<Location?> location = await LocationService.instance.getLocation();

    if (location.status == Status.success && location.data != null) {
      await LocationService.instance.getAddressFromLatLng(location.data!.latitude, location.data!.longitude);
    }
  }

  Future<String?> _trackingTransparencyRequest() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.authorized) {
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      return uuid;
    } else if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      return uuid;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: state.screen,
          bottomNavigationBar: const UserAppNavigationBar(),
        );
      },
    );
  }
}
