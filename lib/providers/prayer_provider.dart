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
      
      // Clear old prayers for today
      final today = DateTime.now();
      final todayKey = _getDateKey(today);
      final oldPrayers = _prayerBox?.values
          .where((prayer) => _getDateKey(prayer.date) == todayKey)
          .toList() ?? [];
      
      for (final prayer in oldPrayers) {
        await prayer.delete();
      }

      // Save new prayers
      for (final prayer in prayers) {
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