import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'gps_service.dart';

class GpsTracker {
  StreamSubscription<Position>? _positionStream;
  final Function(Position) onLocationUpdate;
  final Function(String) onError;

  GpsTracker({required this.onLocationUpdate, required this.onError});

  Future<void> startTracking() async {
    try {
      bool hasPermission = await GpsService.requestLocationPermission();
      if (!hasPermission) {
        onError('Location permission denied');
        return;
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          onLocationUpdate(position);
        },
        onError: (error) {
          onError('Error tracking location: $error');
        },
      );
    } catch (e) {
      onError('Failed to start tracking: $e');
    }
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  bool get isTracking => _positionStream != null;
}
