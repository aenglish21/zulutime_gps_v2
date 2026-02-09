import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.yellow[700]!.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // GPS Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: locationService.isTracking
                            ? Colors.green
                            : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GPS Location',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  // GPS Toggle Button
                  IconButton(
                    icon: Icon(
                      locationService.isTracking
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.yellow[700],
                      size: 32,
                    ),
                    onPressed: () {
                      if (locationService.isTracking) {
                        locationService.stopTracking();
                      } else {
                        locationService.startTracking();
                      }
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Error message or GPS data
              if (locationService.errorMessage.isNotEmpty)
                Text(
                  locationService.errorMessage,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                )
              else if (locationService.currentPosition != null)
                Column(
                  children: [
                    // Coordinates
                    _buildInfoRow(
                      'Coordinates',
                      locationService.formattedCoordinates,
                    ),
                    const SizedBox(height: 8),
                    
                    // Latitude
                    _buildInfoRow(
                      'Latitude',
                      '${locationService.latitude}°',
                    ),
                    const SizedBox(height: 8),
                    
                    // Longitude
                    _buildInfoRow(
                      'Longitude',
                      '${locationService.longitude}°',
                    ),
                    const SizedBox(height: 8),
                    
                    // Altitude
                    _buildInfoRow(
                      'Altitude',
                      '${locationService.altitude} m',
                    ),
                    const SizedBox(height: 8),
                    
                    // Accuracy
                    _buildInfoRow(
                      'Accuracy',
                      '±${locationService.accuracy} m',
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    locationService.isTracking
                        ? 'Acquiring GPS signal...'
                        : 'Tap play to start GPS tracking',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Refresh button (when not tracking)
              if (!locationService.isTracking && 
                  locationService.currentPosition != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextButton.icon(
                    onPressed: () => locationService.getCurrentLocation(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh Location'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.yellow[700],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
