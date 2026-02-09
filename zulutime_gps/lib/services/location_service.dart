import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService with ChangeNotifier {
  Position? _currentPosition;
  String _statusMessage = 'Location not initialized';
  bool _isTracking = false;
  
  Position? get currentPosition => _currentPosition;
  String get statusMessage => _statusMessage;
  bool get isTracking => _isTracking;
  
  // Formatted coordinates
  String get latitude => _currentPosition != null 
      ? _currentPosition!.latitude.toStringAsFixed(6) 
      : '--';
  
  String get longitude => _currentPosition != null 
      ? _currentPosition!.longitude.toStringAsFixed(6) 
      : '--';
  
  String get altitude => _currentPosition != null 
      ? '${_currentPosition!.altitude.toStringAsFixed(1)} m' 
      : '--';
  
  String get accuracy => _currentPosition != null 
      ? '±${_currentPosition!.accuracy.toStringAsFixed(1)} m' 
      : '--';
  
  // Check and request location permissions
  Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _statusMessage = 'Location services disabled';
      notifyListeners();
      return false;
    }
    
    // Request permission
    var status = await Permission.location.status;
    
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    
    if (status.isPermanentlyDenied) {
      _statusMessage = 'Location permission permanently denied';
      notifyListeners();
      return false;
    }
    
    if (status.isGranted) {
      _statusMessage = 'Location permission granted';
      notifyListeners();
      return true;
    }
    
    _statusMessage = 'Location permission denied';
    notifyListeners();
    return false;
  }
  
  // Start location tracking
  Future<void> startTracking() async {
    if (_isTracking) return;
    
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) return;
    
    _isTracking = true;
    _statusMessage = 'Acquiring location...';
    notifyListeners();
    
    try {
      // Get initial position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _statusMessage = 'Location acquired';
      notifyListeners();
      
      // Start continuous tracking
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );
      
      Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position position) {
          _currentPosition = position;
          _statusMessage = 'Tracking active';
          notifyListeners();
        },
        onError: (error) {
          _statusMessage = 'Error: ${error.toString()}';
          notifyListeners();
        },
      );
    } catch (e) {
      _statusMessage = 'Error: ${e.toString()}';
      _isTracking = false;
      notifyListeners();
    }
  }
  
  // Stop location tracking
  void stopTracking() {
    _isTracking = false;
    _statusMessage = 'Tracking stopped';
    notifyListeners();
  }
  
  // Get one-time location
  Future<void> getCurrentLocation() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) return;
    
    try {
      _statusMessage = 'Getting location...';
      notifyListeners();
      
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _statusMessage = 'Location updated';
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error: ${e.toString()}';
      notifyListeners();
    }
  }
}
