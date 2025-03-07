import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:epi_http/epi_http.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner/bloc/partner/partner_bloc.dart';
import 'package:partner/cubit/navigation/navigation_cubit.dart';
import 'package:partner/screens/landing/widgets/bottom_navigation_bar.dart';
import 'package:partner/services/location.dart';
import 'package:partner/widgets/wave_dots.dart';

class LandigScreen extends StatefulWidget {
  const LandigScreen({super.key});

  @override
  State<LandigScreen> createState() => _LandigScreenState();
}

class _LandigScreenState extends State<LandigScreen> {
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
        return BlocBuilder<PartnerBloc, PartnerState>(
          builder: (context, partnerState) {
            if (partnerState is PartnerLoaded) {
              final partner = partnerState.partner;

              if (partner.approved) {
                return Scaffold(
                  body: state.screen,
                  bottomNavigationBar: const PartnerAppNavigationBar(),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Hesabınızın uygulamaya erişimi henüz onaylanmamıştır. Onay süreci tamamlandığında uygulamayı kullanabilirsiniz.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: WaveDots(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
