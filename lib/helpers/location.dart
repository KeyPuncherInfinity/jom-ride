import 'package:geolocator/geolocator.dart';

bool isLocationPermissionGranted(LocationPermission permission) {
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
}

Future<bool> getLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  return isLocationPermissionGranted(permission);
}

Future<Position> getCurrentPosition() async {
  if (!(await getLocationPermission())) {
    throw 'location_permission_not_granted';
  }

  if (!(await Geolocator.isLocationServiceEnabled())) {
    throw 'location_service_not_enabled';
  }

  return Geolocator.getCurrentPosition();
}

Future<Stream<Position>> streamCurrentPosition() async {
  if (!(await getLocationPermission())) {
    throw 'location_permission_not_granted';
  }

  if (!(await Geolocator.isLocationServiceEnabled())) {
    throw 'location_service_not_enabled';
  }

  return Geolocator.getPositionStream();
}
