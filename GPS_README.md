# GPS Integration in Flutter

This Flutter app demonstrates how to integrate GPS functionality using the `geolocator` package.

## Features

- ✅ Get current location
- ✅ Request location permissions
- ✅ Display location data (latitude, longitude, accuracy, altitude, speed)
- ✅ Continuous location tracking
- ✅ Error handling
- ✅ Cross-platform support (Android & iOS)

## Dependencies

The following packages are used for GPS functionality:

```yaml
dependencies:
  geolocator: ^11.0.0
  permission_handler: ^11.3.1
```

## Setup

### 1. Android Permissions

Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### 2. iOS Permissions

Add the following keys to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open to show your current position on the map.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background to track your position.</string>
```

## Usage

### Basic Location Service

```dart
import 'gps_service.dart';

// Get current location
Position? position = await GpsService.getCurrentLocation();
if (position != null) {
  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');
  print('Accuracy: ${position.accuracy}m');
}
```

### Continuous Tracking

```dart
import 'gps_tracker.dart';

GpsTracker tracker = GpsTracker(
  onLocationUpdate: (Position position) {
    print('New location: ${position.latitude}, ${position.longitude}');
  },
  onError: (String error) {
    print('Error: $error');
  },
);

// Start tracking
await tracker.startTracking();

// Stop tracking
tracker.stopTracking();
```

### Permission Handling

The `GpsService` class automatically handles permission requests:

```dart
bool hasPermission = await GpsService.requestLocationPermission();
if (hasPermission) {
  // Proceed with location operations
} else {
  // Handle permission denied
}
```

## Location Data Available

When you get a `Position` object, you have access to:

- **latitude**: Current latitude
- **longitude**: Current longitude
- **accuracy**: Accuracy in meters
- **altitude**: Altitude in meters
- **speed**: Speed in meters per second
- **heading**: Direction of movement
- **timestamp**: When the location was obtained

## Error Handling

The app includes comprehensive error handling for:

- Location services disabled
- Permission denied
- GPS signal issues
- Network connectivity problems

## Testing

To test the GPS functionality:

1. Run the app on a physical device (GPS doesn't work well on simulators)
2. Grant location permissions when prompted
3. Tap "Get Current Location" to see your coordinates
4. For continuous tracking, use the `GpsTracker` class

## Troubleshooting

### Common Issues

1. **Location not updating**: Make sure you're testing on a physical device
2. **Permission denied**: Check that location permissions are granted in device settings
3. **Poor accuracy**: Ensure you're outdoors with clear GPS signal
4. **Background location**: Requires additional setup for background tracking

### Debug Tips

- Use `Geolocator.isLocationServiceEnabled()` to check if location services are enabled
- Use `Geolocator.checkPermission()` to check current permission status
- Monitor the console for error messages

## Next Steps

To extend this GPS functionality, consider adding:

- Map integration with `google_maps_flutter` or `flutter_map`
- Route tracking and navigation
- Geofencing capabilities
- Location history storage
- Background location updates
