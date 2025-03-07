import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_http/epi_http.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:open_apps_settings_fork/open_apps_settings.dart';
import 'package:open_apps_settings_fork/settings_enum.dart';
import 'package:user/services/location.dart';
import 'package:user/widgets/wave_dots.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          size: 64,
          color: context.theme.colorScheme.primary,
        ),
        context.smallGap,
        Text(
          'Konum izinleri kapalı',
          style: context.theme.textTheme.titleMedium!.copyWith(
            color: context.theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Yakındaki kampanyaları görebilmek için konum izni vermelisiniz.',
          style: context.theme.textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        context.largeGap,
        FilledButton(
          onPressed: () async {
            setState(() => isLoading = true);
            final EpiResponse<Location?> location = await LocationService.instance.getLocation();
            if (location.status == Status.success) {
              final data = location.data!;
              await LocationService.instance.getAddressFromLatLng(data.latitude, data.longitude);
            } else {
              setState(() => isLoading = false);
              await OpenAppsSettings.openAppsSettings(
                settingsCode: SettingsCode.LOCATION,
              );
            }
          },
          child: isLoading
              ? const WaveDots(color: Colors.white)
              : const Text(
                  'Konum İzni Ver',
                ),
        ),
      ],
    );
  }
}
