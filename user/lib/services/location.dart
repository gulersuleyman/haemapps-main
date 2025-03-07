import 'package:epi_http/epi_http.dart';
import 'package:fl_location/fl_location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get_storage/get_storage.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  Future<EpiResponse<bool>> checkAndRequestLocationPermission({bool background = false}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      return EpiResponse.error(
        false,
        message: 'Location services are disabled on the device',
      );
    }

    LocationPermission permission = await FlLocation.checkLocationPermission();

    if (permission == LocationPermission.deniedForever) {
      /// The user denied the location permission forever
      /// only way to get the permission is to open the app settings
      return EpiResponse.error(
        false,
        message: 'Location permission denied forever',
      );
    } else if (permission == LocationPermission.denied) {
      /// Ask the user for the location permission
      permission = await FlLocation.requestLocationPermission();

      if (permission == LocationPermission.deniedForever) {
        return EpiResponse.error(
          false,
          message: 'Used denied location permission forever. Need to direct user to app settings',
        );
      } else if (permission == LocationPermission.denied) {
        return EpiResponse.error(
          false,
          message: 'User denied location permission',
        );
      }
    }

    if (background && permission == LocationPermission.whileInUse) {
      return EpiResponse.error(
        false,
        message: 'Location permission is not set to while in use. Permission must be [LocationPermission.always] to track location in the background',
      );
    }

    return EpiResponse.success(true, message: 'Location permission granted with background:$background');
  }

  Future<EpiResponse<Location?>> getLocation() async {
    final bool hasPermission = await checkAndRequestLocationPermission().then((value) => value.status == Status.success);

    if (hasPermission) {
      final Location location = await FlLocation.getLocation();
      await GetStorage().write('geo', {
        'lat': location.latitude,
        'lon': location.longitude,
      });
      await GetStorage().write('firstLogin', false);
      return EpiResponse.success(location, message: '${location.latitude}, ${location.longitude}');
    } else {
      await GetStorage().write('firstLogin', false);
      return EpiResponse.error(null, message: 'Location permission is not granted');
    }
  }

  Future<EpiResponse<geocoding.Placemark?>> getAddressFromLatLng(double lat, double lng) async {
    try {
      final List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
      final geocoding.Placemark place = placemarks[0];
      await GetStorage().write('address', {
        'street': place.street,
        'locality': place.locality,
        'postalCode': place.postalCode,
        'country': place.country,
      });
      return EpiResponse.success(place, message: '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}');
    } catch (e) {
      return EpiResponse.error(null, message: e.toString());
    }
  }
}
