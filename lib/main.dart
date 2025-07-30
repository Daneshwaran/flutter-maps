import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'gps_service.dart';
import 'map_screen.dart';
import 'bluetooth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Location App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GpsLocationPage(title: 'GPS Location Tracker'),
    );
  }
}

class GpsLocationPage extends StatefulWidget {
  const GpsLocationPage({super.key, required this.title});

  final String title;

  @override
  State<GpsLocationPage> createState() => _GpsLocationPageState();
}

class _GpsLocationPageState extends State<GpsLocationPage> {
  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = 'Tap the button to get your location';

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Getting your location...';
    });

    try {
      Position? position = await GpsService.getCurrentLocation();

      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _statusMessage =
            position != null
                ? 'Location obtained successfully!'
                : 'Failed to get location. Please check permissions.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 80,
              color: _currentPosition != null ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (_currentPosition != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Latitude',
                        _currentPosition!.latitude.toStringAsFixed(6),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Longitude',
                        _currentPosition!.longitude.toStringAsFixed(6),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Accuracy',
                        '${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Altitude',
                        '${_currentPosition!.altitude.toStringAsFixed(1)}m',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Speed',
                        '${_currentPosition!.speed.toStringAsFixed(1)} m/s',
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Get Current Location'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MapScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Go to Location'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const BluetoothScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.bluetooth),
                    label: const Text('List Bluetooth Devices'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
