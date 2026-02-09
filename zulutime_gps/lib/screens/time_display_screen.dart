import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/time_service.dart';
import '../services/location_service.dart';

class TimeDisplayScreen extends StatefulWidget {
  const TimeDisplayScreen({super.key});

  @override
  State<TimeDisplayScreen> createState() => _TimeDisplayScreenState();
}

class _TimeDisplayScreenState extends State<TimeDisplayScreen> {
  @override
  void initState() {
    super.initState();
    // Start location tracking on app launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationService>().startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'ZuluTime',
          style: TextStyle(
            color: Color(0xFFFFEB3B), // Yellow
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed, color: Colors.white),
            onPressed: () {
              context.read<LocationService>().getCurrentLocation();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // UTC Time Display
                Consumer<TimeService>(
                  builder: (context, timeService, child) {
                    return Column(
                      children: [
                        const Text(
                          'UTC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          timeService.utcTimeFormatted,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          timeService.utcDateFormatted,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                
                // Local Time Display
                Consumer<TimeService>(
                  builder: (context, timeService, child) {
                    return Column(
                      children: [
                        const Text(
                          'Local',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          timeService.localTimeFormatted,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          timeService.localDateFormatted,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeService.timezoneOffset,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                
                // GPS Location Display
                Consumer<LocationService>(
                  builder: (context, locationService, child) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFEB3B),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                locationService.isTracking
                                    ? Icons.gps_fixed
                                    : Icons.gps_off,
                                color: locationService.isTracking
                                    ? const Color(0xFFFFEB3B)
                                    : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'GPS Location',
                                style: TextStyle(
                                  color: Color(0xFFFFEB3B),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildLocationRow('Latitude:', locationService.latitude),
                          const SizedBox(height: 8),
                          _buildLocationRow('Longitude:', locationService.longitude),
                          const SizedBox(height: 8),
                          _buildLocationRow('Altitude:', locationService.altitude),
                          const SizedBox(height: 8),
                          _buildLocationRow('Accuracy:', locationService.accuracy),
                          const SizedBox(height: 12),
                          Text(
                            locationService.statusMessage,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
