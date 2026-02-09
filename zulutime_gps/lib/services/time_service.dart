import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TimeService with ChangeNotifier {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  
  DateTime get currentTime => _currentTime;
  
  // UTC time
  DateTime get utcTime => _currentTime.toUtc();
  
  // Formatted times
  String get utcTimeFormatted => DateFormat('HH:mm:ss').format(utcTime);
  String get utcDateFormatted => DateFormat('yyyy-MM-dd').format(utcTime);
  
  String get localTimeFormatted => DateFormat('HH:mm:ss').format(_currentTime);
  String get localDateFormatted => DateFormat('yyyy-MM-dd').format(_currentTime);
  
  // Timezone offset
  String get timezoneOffset {
    final offset = _currentTime.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60).abs();
    final sign = hours >= 0 ? '+' : '';
    return '$sign${hours.toString().padLeft(2, '0')}${minutes.toString().padLeft(2, '0')}';
  }
  
  TimeService() {
    _startTimer();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime = DateTime.now();
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
