import 'package:geolocator/geolocator.dart';

class GpsService {
  static Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<List<Position>> getLocationHistory() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return [];
      }

      return await Geolocator.getLastKnownPosition().then((position) {
        return position != null ? [position] : [];
      });
    } catch (e) {
      print('Error getting location history: $e');
      return [];
    }
  }

  static Future<double?> getDistanceFromLocation(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e) {
      print('Error calculating distance: $e');
      return null;
    }
  }
}
