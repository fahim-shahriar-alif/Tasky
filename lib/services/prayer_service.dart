import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/prayer.dart';

class PrayerService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';
  
  // Default location (Mecca) if location access is denied
  static const double _defaultLat = 21.4225;
  static const double _defaultLng = 39.8262;

  /// Get current location with permission handling
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Fetch prayer times from Aladhan API
  static Future<List<Prayer>> fetchPrayerTimes({
    double? latitude,
    double? longitude,
    DateTime? date,
    int calculationMethod = 5, // Default to Karachi method for Bangladesh
  }) async {
    try {
      // Use provided coordinates or get current location
      double lat = latitude ?? _defaultLat;
      double lng = longitude ?? _defaultLng;
      
      if (latitude == null || longitude == null) {
        final position = await getCurrentLocation();
        if (position != null) {
          lat = position.latitude;
          lng = position.longitude;
        }
      }

      final targetDate = date ?? DateTime.now();
      final dateString = '${targetDate.day.toString().padLeft(2, '0')}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.year}';

      // Method 5: University of Islamic Sciences, Karachi - Best for Bangladesh/Pakistan region
      final url = '$_baseUrl/timings/$dateString?latitude=$lat&longitude=$lng&method=$calculationMethod';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        return _parsePrayerTimes(timings, targetDate);
      } else {
        throw Exception('Failed to fetch prayer times: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
      // Return default prayer times if API fails
      return _getDefaultPrayerTimes(date ?? DateTime.now());
    }
  }

  /// Parse API response into Prayer objects
  static List<Prayer> _parsePrayerTimes(Map<String, dynamic> timings, DateTime date) {
    final prayers = <Prayer>[];
    
    for (int i = 0; i < Prayer.prayerNames.length; i++) {
      final prayerName = Prayer.prayerNames[i];
      final arabicName = Prayer.arabicNames[i];
      
      // Map prayer names to API response keys
      String apiKey;
      switch (prayerName) {
        case 'Dhuhr':
          apiKey = 'Dhuhr';
          break;
        default:
          apiKey = prayerName;
      }

      final timeString = timings[apiKey] as String?;
      if (timeString != null) {
        final prayerTime = _parseTime(timeString, date);
        prayers.add(Prayer(
          name: prayerName,
          arabicName: arabicName,
          time: prayerTime,
          date: date,
        ));
      }
    }

    return prayers;
  }

  /// Parse time string (HH:mm) into DateTime
  static DateTime _parseTime(String timeString, DateTime date) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// Get default prayer times if API fails
  static List<Prayer> _getDefaultPrayerTimes(DateTime date) {
    final defaultTimes = [
      '05:30', // Fajr
      '13:00', // Dhuhr
      '16:30', // Asr
      '19:00', // Maghrib
      '20:30', // Isha
    ];

    final prayers = <Prayer>[];
    
    for (int i = 0; i < Prayer.prayerNames.length; i++) {
      final prayerTime = _parseTime(defaultTimes[i], date);
      prayers.add(Prayer(
        name: Prayer.prayerNames[i],
        arabicName: Prayer.arabicNames[i],
        time: prayerTime,
        date: date,
      ));
    }

    return prayers;
  }

  /// Get next prayer from current time
  static Prayer? getNextPrayer(List<Prayer> prayers) {
    final now = DateTime.now();
    
    for (final prayer in prayers) {
      if (!prayer.hasPassed) {
        return prayer;
      }
    }
    
    // If all prayers have passed, return Fajr of next day
    return null;
  }

  /// Calculate prayer completion percentage
  static double getPrayerCompletionPercentage(List<Prayer> prayers) {
    if (prayers.isEmpty) return 0.0;
    
    final completed = prayers.where((p) => p.isCompleted).length;
    return (completed / prayers.length) * 100;
  }
}