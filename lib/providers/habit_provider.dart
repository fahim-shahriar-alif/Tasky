import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<HabitLog> _habitLogs = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  List<HabitLog> get habitLogs => _habitLogs;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  // Get habit logs for selected date
  List<HabitLog> get selectedDateLogs {
    return _habitLogs.where((log) => log.isForDate(_selectedDate)).toList();
  }

  // Get completion status for a habit on selected date
  bool isHabitCompletedOnDate(String habitId, DateTime date) {
    // Allow tracking habits for any date, regardless of when the habit was created
    final log = _habitLogs.firstWhere(
      (log) => log.habitId == habitId && log.isForDate(date),
      orElse: () => HabitLog(
        id: '',
        habitId: habitId,
        date: date,
        isCompleted: false,
      ),
    );
    return log.isCompleted;
  }

  // Check if a habit is available for tracking on a given date
  bool isHabitAvailableForDate(String habitId, DateTime date) {
    // ALL habits are available for tracking on ANY date
    // This allows retroactive tracking regardless of when the habit was created
    final habit = _habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => Habit(id: '', name: '', createdAt: DateTime.now()),
    );
    
    // Return true if the habit exists and is active
    return habit.id.isNotEmpty && habit.isActive;
  }

  // Get all habits that should be available for the selected date
  // This includes ALL habits regardless of when they were created
  List<Habit> get habitsForSelectedDate {
    // Return ALL active habits - users should be able to track any habit for any date
    // This is the key fix: habits are not filtered by creation date
    return _habits.where((habit) => habit.isActive).toList();
  }

  // Get all habits available for the selected date
  List<Habit> get availableHabitsForSelectedDate {
    // Return all habits - they can be tracked for any date
    // This allows users to mark habits as completed for previous days,
    // even if the habit was created after that date
    return habitsForSelectedDate;
  }

  // Get habits created before or on a specific date (for future use if needed)
  List<Habit> getHabitsCreatedByDate(DateTime date) {
    return _habits.where((habit) => 
      habit.createdAt.isBefore(date.add(const Duration(days: 1)))
    ).toList();
  }
  int getHabitStreak(String habitId) {
    // Get all completed logs for this habit, sorted by date (newest first)
    final completedLogs = _habitLogs
        .where((log) => log.habitId == habitId && log.isCompleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (completedLogs.isEmpty) return 0;

    // Get today's date (normalized)
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    
    // Create a set of all completed dates for quick lookup (only past and today)
    final completedDates = <String>{};
    for (final log in completedLogs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      
      // Only include dates that are today or in the past
      if (logDate.isBefore(todayNormalized) || logDate.isAtSameMomentAs(todayNormalized)) {
        completedDates.add('${logDate.year}-${logDate.month.toString().padLeft(2, '0')}-${logDate.day.toString().padLeft(2, '0')}');
      }
    }
    
    // Count consecutive days starting from today and going backwards
    int streak = 0;
    DateTime currentDate = todayNormalized;
    
    // Check each day going backwards from today
    while (true) {
      final dateKey = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
      
      if (completedDates.contains(dateKey)) {
        // This date is completed, increment streak
        streak++;
        // Move to previous day
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        // This date is not completed, streak is broken
        break;
      }
    }
    
    return streak;
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  // Load habits and logs from storage
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = StorageService.getAllHabits();
      _habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      
      // Load all habit logs
      _habitLogs = [];
      for (final habit in _habits) {
        final logs = StorageService.getHabitLogs(habit.id);
        _habitLogs.addAll(logs);
      }
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new habit
  Future<void> addHabit({
    required String name,
    String? description,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name.trim(),
      description: description?.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await StorageService.saveHabit(habit);
      _habits.add(habit);
      _habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit: $e');
      rethrow;
    }
  }

  // Update habit
  Future<void> updateHabit({
    required String habitId,
    String? name,
    String? description,
  }) async {
    final habitIndex = _habits.indexWhere((habit) => habit.id == habitId);
    if (habitIndex == -1) return;

    final habit = _habits[habitIndex];
    if (name != null) habit.name = name.trim();
    if (description != null) habit.description = description.trim();

    try {
      await StorageService.saveHabit(habit);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  // Delete habit
  Future<void> deleteHabit(String habitId) async {
    try {
      await StorageService.deleteHabit(habitId);
      _habits.removeWhere((habit) => habit.id == habitId);
      _habitLogs.removeWhere((log) => log.habitId == habitId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  // Toggle habit completion for selected date
  Future<void> toggleHabitCompletion(String habitId) async {
    // Normalize the selected date to avoid time issues
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    
    final existingLogIndex = _habitLogs.indexWhere(
      (log) => log.habitId == habitId && log.isForDate(normalizedDate),
    );

    HabitLog log;
    if (existingLogIndex != -1) {
      // Update existing log
      log = _habitLogs[existingLogIndex];
      log.isCompleted = !log.isCompleted;
    } else {
      // Create new log
      log = HabitLog(
        id: const Uuid().v4(),
        habitId: habitId,
        date: normalizedDate,
        isCompleted: true,
      );
      _habitLogs.add(log);
    }

    try {
      await StorageService.saveHabitLog(log);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling habit completion: $e');
      // Revert the change if save failed
      if (existingLogIndex != -1) {
        log.isCompleted = !log.isCompleted;
      } else {
        _habitLogs.remove(log);
      }
      rethrow;
    }
  }

  // Add note to habit log
  Future<void> addHabitNote(String habitId, String note) async {
    // Normalize the selected date to avoid time issues
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    
    final existingLogIndex = _habitLogs.indexWhere(
      (log) => log.habitId == habitId && log.isForDate(normalizedDate),
    );

    HabitLog log;
    if (existingLogIndex != -1) {
      log = _habitLogs[existingLogIndex];
      log.notes = note.trim();
    } else {
      log = HabitLog(
        id: const Uuid().v4(),
        habitId: habitId,
        date: normalizedDate,
        notes: note.trim(),
      );
      _habitLogs.add(log);
    }

    try {
      await StorageService.saveHabitLog(log);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit note: $e');
      rethrow;
    }
  }
}