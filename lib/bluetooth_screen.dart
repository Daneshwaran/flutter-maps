import 'dart:async';
import 'package:flutter/material.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<Map<String, String>> _devices = [];
  bool _isScanning = false;
  String _statusMessage = 'Bluetooth functionality coming soon!';

  @override
  void initState() {
    super.initState();
    _loadMockDevices();
  }

  void _loadMockDevices() {
    setState(() {
      _devices = [
        {'name': 'Mock Device 1', 'id': '00:11:22:33:44:55', 'type': 'Classic'},
        {'name': 'Mock Device 2', 'id': 'AA:BB:CC:DD:EE:FF', 'type': 'BLE'},
      ];
    });
  }

  Future<void> _startScan() async {
    try {
      setState(() {
        _isScanning = true;
        _statusMessage = 'Scanning for Bluetooth devices...';
        _devices.clear();
      });

      // Simulate scanning
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isScanning = false;
        _devices = [
          {
            'name': 'Mock Device 1',
            'id': '00:11:22:33:44:55',
            'type': 'Classic',
          },
          {'name': 'Mock Device 2', 'id': 'AA:BB:CC:DD:EE:FF', 'type': 'BLE'},
        ];
        _statusMessage = 'Found ${_devices.length} device(s)';
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _connectToDevice(Map<String, String> device) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to ${device['name']}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _disconnectFromDevice(Map<String, String> device) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnected from ${device['name']}'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnect failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _isScanning ? null : _startScan,
            icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
            tooltip: _isScanning ? 'Scanning...' : 'Scan for devices',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                Icon(
                  _isScanning ? Icons.bluetooth_searching : Icons.bluetooth,
                  color: _isScanning ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (_isScanning)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Device list
          Expanded(
            child:
                _devices.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bluetooth_disabled,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isScanning ? 'Scanning...' : 'No devices found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Make sure Bluetooth is enabled and devices are discoverable',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.bluetooth),
                            title: Text(
                              device['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${device['id']}\nType: ${device['type']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _connectToDevice(device),
                                  icon: const Icon(Icons.link),
                                  tooltip: 'Connect',
                                  color: Colors.green,
                                ),
                                IconButton(
                                  onPressed:
                                      () => _disconnectFromDevice(device),
                                  icon: const Icon(Icons.link_off),
                                  tooltip: 'Disconnect',
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text(device['name']!),
                                      content: Text(
                                        'ID: ${device['id']}\n'
                                        'Name: ${device['name']}\n'
                                        'Type: ${device['type']}',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
