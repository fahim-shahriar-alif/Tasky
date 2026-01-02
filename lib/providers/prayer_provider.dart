import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/prayer.dart';
import '../models/bangladesh_district.dart';
import '../services/prayer_service.dart';

class PrayerProvider extends ChangeNotifier {
  static const String _prayerBoxName = 'prayers';
  static const String _settingsBoxName = 'prayer_settings';
  
  Box<Prayer>? _prayerBox;
  Box? _settingsBox;
  List<Prayer> _todayPrayers = [];
  bool _isLoading = false;
  String? _error;
  DateTime _lastFetchDate = DateTime.now();
  BangladeshDistrict _selectedDistrict = BangladeshDistrict.allDistricts.first; // Default to Dhaka

  // Getters
  List<Prayer> get todayPrayers => _todayPrayers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  BangladeshDistrict get selectedDistrict => _selectedDistrict;

  /// Initialize prayer provider
  Future<void> init() async {
    try {
      _prayerBox = await Hive.openBox<Prayer>(_prayerBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      
      // Load saved district
      final savedDistrictName = _settingsBox?.get('selected_district');
      if (savedDistrictName != null) {
        final district = BangladeshDistrict.findByName(savedDistrictName);
        if (district != null) {
          _selectedDistrict = district;
        }
      }
      
      await _loadTodayPrayers();
    } catch (e) {
      _error = 'Failed to initialize prayers: $e';
      notifyListeners();
    }
  }

  /// Load today's prayers from storage or fetch from API
  Future<void> _loadTodayPrayers() async {
    final today = DateTime.now();
    final todayKey = _getDateKey(today);

    // Check if we have today's prayers in storage
    final storedPrayers = _prayerBox?.values
        .where((prayer) => _getDateKey(prayer.date) == todayKey)
        .toList() ?? [];

    if (storedPrayers.isNotEmpty && _isSameDay(today, _lastFetchDate)) {
      _todayPrayers = storedPrayers;
      _todayPrayers.sort((a, b) => a.time.compareTo(b.time));
      notifyListeners();
    } else {
      await fetchTodayPrayers();
    }
  }

  /// Fetch today's prayers from API
  Future<void> fetchTodayPrayers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prayers = await PrayerService.fetchPrayerTimes(
        latitude: _selectedDistrict.latitude,
        longitude: _selectedDistrict.longitude,
      );
      
      // Get existing prayers for today to preserve completion status
      final today = DateTime.now();
      final todayKey = _getDateKey(today);
      final oldPrayers = _prayerBox?.values
          .where((prayer) => _getDateKey(prayer.date) == todayKey)
          .toList() ?? [];
      
      // Create a map of existing completion status by prayer name
      final completionStatus = <String, bool>{};
      for (final oldPrayer in oldPrayers) {
        completionStatus[oldPrayer.name] = oldPrayer.isCompleted;
      }
      
      // Clear old prayers for today
      for (final prayer in oldPrayers) {
        await prayer.delete();
      }

      // Save new prayers with preserved completion status
      for (final prayer in prayers) {
        // Preserve completion status if it existed
        if (completionStatus.containsKey(prayer.name)) {
          prayer.isCompleted = completionStatus[prayer.name]!;
        }
        await _prayerBox?.add(prayer);
      }

      _todayPrayers = prayers;
      _lastFetchDate = today;
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch prayer times: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle prayer completion status
  Future<void> togglePrayerCompletion(int index) async {
    if (index < 0 || index >= _todayPrayers.length) return;

    final prayer = _todayPrayers[index];
    prayer.isCompleted = !prayer.isCompleted;
    
    try {
      await prayer.save();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update prayer: $e';
      notifyListeners();
    }
  }

  /// Get next prayer
  Prayer? getNextPrayer() {
    return PrayerService.getNextPrayer(_todayPrayers);
  }

  /// Get prayer completion percentage
  double getCompletionPercentage() {
    return PrayerService.getPrayerCompletionPercentage(_todayPrayers);
  }

  /// Get completed prayers count
  int getCompletedCount() {
    return _todayPrayers.where((p) => p.isCompleted).length;
  }

  /// Get prayers for a specific date
  List<Prayer> getPrayersForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _prayerBox?.values
        .where((prayer) => _getDateKey(prayer.date) == dateKey)
        .toList() ?? [];
  }

  /// Get prayer completion rate for a specific date
  double getCompletionRateForDate(DateTime date) {
    final prayers = getPrayersForDate(date);
    if (prayers.isEmpty) return 0.0;
    final completed = prayers.where((p) => p.isCompleted).length;
    return (completed / prayers.length) * 100;
  }

  /// Get prayer completion data for the last N days
  Map<DateTime, double> getWeeklyCompletionData({int days = 7}) {
    final Map<DateTime, double> data = {};
    final now = DateTime.now();
    
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      data[date] = getCompletionRateForDate(date);
    }
    
    return data;
  }

  /// Get total prayers completed in the last N days
  int getTotalCompletedInDays({int days = 7}) {
    final now = DateTime.now();
    int total = 0;
    
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final prayers = getPrayersForDate(date);
      total += prayers.where((p) => p.isCompleted).length;
    }
    
    return total;
  }

  /// Get prayer streak (consecutive days with all prayers completed)
  int getPrayerStreak() {
    final now = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) { // Check up to a year
      final date = DateTime(now.year, now.month, now.day - i);
      final prayers = getPrayersForDate(date);
      
      if (prayers.isEmpty) break; // No data for this date
      
      final completionRate = getCompletionRateForDate(date);
      if (completionRate == 100.0) {
        streak++;
      } else {
        break; // Streak broken
      }
    }
    
    return streak;
  }

  /// Get prayer statistics for individual prayers over time
  Map<String, Map<String, int>> getPrayerWiseStats({int days = 30}) {
    final Map<String, Map<String, int>> stats = {};
    final now = DateTime.now();
    
    // Initialize stats for each prayer
    for (final prayerName in Prayer.prayerNames) {
      stats[prayerName] = {'completed': 0, 'total': 0};
    }
    
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final prayers = getPrayersForDate(date);
      
      for (final prayer in prayers) {
        if (stats.containsKey(prayer.name)) {
          stats[prayer.name]!['total'] = (stats[prayer.name]!['total'] ?? 0) + 1;
          if (prayer.isCompleted) {
            stats[prayer.name]!['completed'] = (stats[prayer.name]!['completed'] ?? 0) + 1;
          }
        }
      }
    }
    
    return stats;
  }

  /// Get best prayer completion day of the week
  String getBestDayOfWeek({int weeks = 4}) {
    final Map<int, List<double>> dayStats = {};
    final now = DateTime.now();
    
    // Initialize for each day of week (1=Monday, 7=Sunday)
    for (int i = 1; i <= 7; i++) {
      dayStats[i] = [];
    }
    
    for (int i = weeks * 7 - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dayOfWeek = date.weekday;
      final completionRate = getCompletionRateForDate(date);
      
      if (completionRate > 0) {
        dayStats[dayOfWeek]!.add(completionRate);
      }
    }
    
    // Calculate average for each day
    double bestAverage = 0;
    int bestDay = 1;
    
    dayStats.forEach((day, rates) {
      if (rates.isNotEmpty) {
        final average = rates.reduce((a, b) => a + b) / rates.length;
        if (average > bestAverage) {
          bestAverage = average;
          bestDay = day;
        }
      }
    });
    
    const dayNames = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return dayNames[bestDay];
  }

  /// Check if prayers need refresh (new day)
  bool needsRefresh() {
    final today = DateTime.now();
    return !_isSameDay(today, _lastFetchDate);
  }

  /// Refresh prayers if needed
  Future<void> refreshIfNeeded() async {
    if (needsRefresh()) {
      await fetchTodayPrayers();
    }
  }

  /// Helper method to generate date key
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Change selected district and fetch new prayer times
  Future<void> changeDistrict(BangladeshDistrict district) async {
    if (_selectedDistrict.name == district.name) return;
    
    _selectedDistrict = district;
    
    // Save selected district
    await _settingsBox?.put('selected_district', district.name);
    
    // Fetch new prayer times for the selected district
    await fetchTodayPrayers();
  }

  /// Get all Bangladesh districts
  List<BangladeshDistrict> getAllDistricts() {
    return BangladeshDistrict.allDistricts;
  }

  /// Dispose resources
  @override
  void dispose() {
    _prayerBox?.close();
    _settingsBox?.close();
    super.dispose();
  }
}