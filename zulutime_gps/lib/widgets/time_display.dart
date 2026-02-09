import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String label;
  final String time;
  final String date;
  final String? timezone;
  final bool isUtc;

  const TimeDisplay({
    super.key,
    required this.label,
    required this.time,
    required this.date,
    this.timezone,
    required this.isUtc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label (UTC or Local)
        Text(
          label,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white70,
            letterSpacing: 4,
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Time display
        Text(
          time,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 8,
            height: 1.0,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Date
        Text(
          date,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white60,
            letterSpacing: 2,
          ),
        ),
        
        // Timezone offset (only for local time)
        if (timezone != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              timezone!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white60,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }
}
